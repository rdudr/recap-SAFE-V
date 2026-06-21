"""POST /v1/verify — resolve a step-up challenge (TOTP / OTP / face)."""

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(tags=["trust-engine"])


class VerifyRequest(BaseModel):
    user_id: str
    channel: str  # TOTP | SMS_OTP | FACE
    code: str | None = None
    face_verified: bool | None = None


@router.post("/verify")
def verify(body: VerifyRequest):
    if body.channel == "TOTP":
        from app.api.v1.totp import _secrets
        import pyotp

        secret = _secrets.get(body.user_id)
        ok = bool(secret and body.code and pyotp.TOTP(secret).verify(body.code, valid_window=1))
    elif body.channel == "SMS_OTP":
        ok = body.code == "123456"  # demo OTP — mock SMS rail
    elif body.channel == "FACE":
        ok = bool(body.face_verified)  # mock verdict (production: certified vendor)
    else:
        ok = False
    return {"verified": ok, "channel": body.channel}
