"""Post-recovery probation: 24h ₹5,000 cap + no payee adds after a step-up recovery.

Mirrors the NPCI ecosystem risk rule for new UPI registrations (say
"NPCI risk-management rule enforced across UPI apps" — no circular number exists).
"""

from datetime import datetime, timedelta, timezone

from app.core.config import settings

# user_id -> {"until": datetime, "spent_inr": float}
_probation: dict[str, dict] = {}


def start(user_id: str) -> dict:
    until = datetime.now(timezone.utc) + timedelta(hours=settings.probation_hours)
    _probation[user_id] = {"until": until, "spent_inr": 0.0}
    return status(user_id)


def status(user_id: str) -> dict:
    p = _probation.get(user_id)
    if not p or p["until"] < datetime.now(timezone.utc):
        return {"active": False}
    return {
        "active": True,
        "until": p["until"].isoformat(),
        "cap_inr": settings.probation_cap_inr,
        "spent_inr": p["spent_inr"],
        "remaining_inr": max(0.0, settings.probation_cap_inr - p["spent_inr"]),
    }


def check(user_id: str, ev: dict) -> dict:
    """Called by fusion on every event; records spend, flags violations."""
    st = status(user_id)
    if not st["active"]:
        return {"active": False, "violation": False}

    violation = False
    if ev.get("event_type") == "add_payee":
        violation = True
    amount = float(ev.get("amount_inr", 0.0))
    if amount > 0:
        if _probation[user_id]["spent_inr"] + amount > settings.probation_cap_inr:
            violation = True
        else:
            _probation[user_id]["spent_inr"] += amount
    return {**status(user_id), "violation": violation}
