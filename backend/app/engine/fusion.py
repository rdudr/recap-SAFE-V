"""Risk fusion: blend rule hits + ML anomaly score into a 0-100 trust decision."""

from app.core.config import settings
from app.engine import explain, ml, probation, rules


def decide(ev: dict) -> dict:
    hits = rules.evaluate(ev)
    ml_score = ml.anomaly_score(ev)

    risk = ml_score
    if any(h.action == "BLOCK" for h in hits):
        risk = max(risk, 90.0)  # rules floor the score
    elif any(h.action == "STEP_UP" for h in hits):
        risk = max(risk, 55.0)

    # Probation tightens everything
    prob = probation.check(ev.get("user_id", ""), ev)
    if prob["violation"]:
        risk = max(risk, 65.0)

    if risk >= settings.block_threshold:
        decision = "BLOCK"
    elif risk >= settings.stepup_threshold:
        decision = "STEP_UP"
    else:
        decision = "ALLOW"

    # Forwarding veto: even on ALLOW, never route OTP via SMS/voice
    sms_vetoed = any(h.action == "VETO_SMS" for h in hits)
    stepup_channel = "TOTP" if (sms_vetoed or ev.get("abroad")) else "SMS_OTP"

    return {
        "user_id": ev.get("user_id"),
        "event_type": ev.get("event_type"),
        "risk_score": round(risk, 1),
        "decision": decision,
        "stepup_channel": stepup_channel if decision == "STEP_UP" else None,
        "sms_vetoed": sms_vetoed,
        "rules_fired": [h.__dict__ for h in hits],
        "ml_anomaly_score": ml_score,
        "top_signals": explain.top_signals(ev, hits, ml_score),
        "probation": prob,
    }
