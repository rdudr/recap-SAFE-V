"""POST /v1/stepup — which step-up challenge to present for a scored event."""

from fastapi import APIRouter
from pydantic import BaseModel

from app.mocks.state import state

router = APIRouter(tags=["trust-engine"])


class StepupRequest(BaseModel):
    user_id: str
    risk_score: float
    sms_vetoed: bool = False


@router.post("/stepup")
def stepup(body: StepupRequest):
    if body.risk_score >= 70:
        channel = "FACE"
    elif body.sms_vetoed or state.abroad:
        channel = "TOTP"  # SIM-free — the NRI/travel story
    else:
        channel = "SMS_OTP"
    return {"channel": channel, "user_id": body.user_id}
