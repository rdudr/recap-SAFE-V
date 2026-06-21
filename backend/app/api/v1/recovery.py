"""Tiered account recovery: risk score decides the ladder rung.

Tier 1 (low):    OTP + device push
Tier 2 (medium): debit-card details + OTP  (mirrors bob World registration factors)
Tier 3 (high):   face match + liveness (mock verdict) + 24h veto window
Success at tier >=2 starts probation (24h / Rs 5,000 cap).
"""

from fastapi import APIRouter
from pydantic import BaseModel

from app.engine import fusion, probation

router = APIRouter(tags=["recovery"])


class RecoveryStart(BaseModel):
    user_id: str
    device_id: str
    new_device: bool = True
    reason: str = "new_phone"  # new_phone | forgot_pin | number_change


@router.post("/recovery/start")
def start(body: RecoveryStart):
    ev = {
        "user_id": body.user_id,
        "event_type": "recovery",
        "new_device": body.new_device,
        "device_id": body.device_id,
    }
    result = fusion.decide(ev)
    tier = 1 if result["decision"] == "ALLOW" else (2 if result["risk_score"] < 70 else 3)
    return {**result, "recovery_tier": tier}


class RecoveryComplete(BaseModel):
    user_id: str
    tier: int
    face_verified: bool | None = None  # tier 3 mock verdict


@router.post("/recovery/complete")
def complete(body: RecoveryComplete):
    if body.tier >= 3 and not body.face_verified:
        return {"recovered": False, "reason": "face verification failed"}
    prob = probation.start(body.user_id) if body.tier >= 2 else {"active": False}
    return {"recovered": True, "tier": body.tier, "probation": prob}
