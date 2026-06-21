"""TOTP for NRI/travel users — the prototype's headline alternative factor.

Bank app = authenticator: secret lives in flutter_secure_storage, codes generate
offline (airplane-mode demo). Server verifies with pyotp (±30s window).
"""

import pyotp
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter(tags=["totp"])

_secrets: dict[str, str] = {}  # user_id -> secret; move to DB table day 21-23


class EnrollRequest(BaseModel):
    user_id: str
    device_id: str


@router.post("/totp/enroll")
def enroll(body: EnrollRequest):
    secret = pyotp.random_base32()
    _secrets[body.user_id] = secret
    uri = pyotp.totp.TOTP(secret).provisioning_uri(name=body.user_id, issuer_name="SAFE-V")
    # app stores `secret` in secure storage (in-app generator) + renders `otpauth_uri` as QR
    return {"secret": secret, "otpauth_uri": uri}


class VerifyRequest(BaseModel):
    user_id: str
    code: str


@router.post("/totp/verify")
def verify(body: VerifyRequest):
    secret = _secrets.get(body.user_id)
    if not secret:
        raise HTTPException(404, "user not enrolled for TOTP")
    ok = pyotp.TOTP(secret).verify(body.code, valid_window=1)
    return {"verified": ok, "factor": "TOTP", "works_offline": True}
