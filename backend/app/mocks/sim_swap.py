"""Mock of the CAMARA SIM Swap API (real shape, simulated data).

Production rail: federated CAMARA SIM Swap API launched by Jio/Airtel/Vi under
GSMA Open Gateway (India Mobile Congress, Oct 2025). Enterprise-gated; this mock
keeps our code production-portable.
"""

from datetime import datetime, timedelta, timezone

from fastapi import APIRouter
from pydantic import BaseModel

from app.mocks.state import state

router = APIRouter(prefix="/sim-swap/v1", tags=["mock-camara"])


class SimSwapRequest(BaseModel):
    phoneNumber: str
    maxAge: int | None = 240  # hours, per CAMARA spec


@router.post("/retrieve-date")
def retrieve_date(body: SimSwapRequest):
    if state.sim_swap_hours_ago is None:
        return {"latestSimChange": None}
    ts = datetime.now(timezone.utc) - timedelta(hours=state.sim_swap_hours_ago)
    return {"latestSimChange": ts.isoformat()}


@router.post("/check")
def check(body: SimSwapRequest):
    swapped = (
        state.sim_swap_hours_ago is not None
        and state.sim_swap_hours_ago <= (body.maxAge or 240)
    )
    return {"swapped": swapped}
