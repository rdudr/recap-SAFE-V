"""Rule layer: hard vetoes and policy-mandated checks. Evaluated BEFORE the ML layer."""

from dataclasses import dataclass

from app.core.config import settings

SENSITIVE_EVENTS = {"upi_rebind", "pin_reset", "add_payee"}


@dataclass
class RuleHit:
    rule: str
    action: str  # "BLOCK" | "STEP_UP" | "VETO_SMS"
    reason: str


def evaluate(ev: dict) -> list[RuleHit]:
    hits: list[RuleHit] = []

    if not ev.get("device_integrity", True):
        hits.append(RuleHit("rooted_device", "BLOCK", "Device integrity verdict failed (policy veto)"))

    sim_hours = ev.get("sim_change_hours")
    if (
        sim_hours is not None
        and sim_hours < settings.sim_swap_veto_hours
        and ev.get("event_type") in SENSITIVE_EVENTS
    ):
        hits.append(
            RuleHit("recent_sim_swap", "BLOCK", f"SIM changed {sim_hours:.0f}h ago — veto on {ev['event_type']}")
        )

    if ev.get("call_forwarding_active"):
        hits.append(
            RuleHit("call_forwarding", "VETO_SMS", "Forwarding active — SMS/voice OTP unsafe, force TOTP/app factor")
        )

    if ev.get("screen_share_active"):
        hits.append(RuleHit("screen_share", "STEP_UP", "Screen share/remote tool active — hold + coercion interstitial"))

    if ev.get("abroad") and not ev.get("travel_declared") and ev.get("new_device"):
        hits.append(RuleHit("undeclared_foreign_new_device", "STEP_UP", "Probable ATO pattern (undeclared geo + new device)"))

    if ev.get("recovery_attempts_same_source", 0) >= 3:
        hits.append(RuleHit("recovery_velocity", "BLOCK", "Same device/IP recovering ≥3 accounts — fraud-ring pattern"))

    return hits
