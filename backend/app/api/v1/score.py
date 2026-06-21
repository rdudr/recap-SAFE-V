"""POST /v1/score — the heart of SAFE-V: score any sensitive event.

The request carries what the app knows (event type, amount, device, typing z).
Server-side signals (SIM swap, forwarding, integrity, geo) are pulled from the
mock rails / demo state — exactly where production would call the real APIs.
"""

from fastapi import APIRouter
from pydantic import BaseModel

from app.engine import fusion
from app.mocks.state import state

router = APIRouter(tags=["trust-engine"])

EVENT_LOG: list[dict] = []  # SOC console polls this (swap for DB/WebSocket later)


class ScoreRequest(BaseModel):
    user_id: str
    event_type: str  # login | payment | upi_rebind | pin_reset | add_payee | recovery
    amount_inr: float = 0.0
    device_id: str = ""
    new_device: bool = False
    typing_z: float = 0.0
    # optional overrides for testing without the demo driver
    amount_pctl: float | None = None
    hour: float | None = None
    geo_km: float | None = None
    device_age_days: float | None = None
    payee_age_days: float | None = None
    recovery_recency_h: float | None = None


@router.post("/score")
def score(body: ScoreRequest):
    ev = body.model_dump()
    # sensible feature defaults when the app doesn't send them
    ev.setdefault("amount_pctl", None)
    if ev["amount_pctl"] is None:
        ev["amount_pctl"] = min(100.0, body.amount_inr / 100.0)
    if ev["hour"] is None:
        from datetime import datetime

        ev["hour"] = datetime.now().hour
    if ev["geo_km"] is None:
        ev["geo_km"] = 4000.0 if state.abroad else 5.0
    if ev["device_age_days"] is None:
        ev["device_age_days"] = 0.0 if body.new_device else 220.0
    if ev["payee_age_days"] is None:
        ev["payee_age_days"] = 100.0
    if ev["recovery_recency_h"] is None:
        ev["recovery_recency_h"] = 600.0

    # merge server-side signals (mock rails — production calls the real APIs here)
    ev["sim_change_hours"] = state.sim_swap_hours_ago
    ev["call_forwarding_active"] = state.call_forwarding_active
    ev["device_integrity"] = state.device_integrity
    ev["screen_share_active"] = state.screen_share_active
    ev["abroad"] = state.abroad
    ev["travel_declared"] = state.travel_declared

    result = fusion.decide(ev)
    EVENT_LOG.append(result)
    return result


@router.get("/events")
def events(limit: int = 50):
    """SOC console feed (poll every 2s)."""
    return EVENT_LOG[-limit:][::-1]
