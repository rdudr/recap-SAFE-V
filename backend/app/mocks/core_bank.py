"""Mock core banking: accounts, cards, UPI handles, sessions, and the kill switch."""

import time

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter(prefix="/core", tags=["mock-core-bank"])

# user_id -> account state (reset via /demo/reset or restart)
ACCOUNTS: dict[str, dict] = {
    "priya": {"balance": 84_500, "card_frozen": False, "upi_frozen": False, "sessions": 1},
    "rahul_nri": {"balance": 2_10_000, "card_frozen": False, "upi_frozen": False, "sessions": 1},
    "attacker_target": {"balance": 1_56_000, "card_frozen": False, "upi_frozen": False, "sessions": 1},
}


class FreezeRequest(BaseModel):
    user_id: str
    freeze_card: bool = True
    freeze_upi: bool = True
    revoke_sessions: bool = True


@router.post("/freeze")
def freeze(body: FreezeRequest):
    """One-tap kill switch. Returns elapsed ms so the app can show the timer."""
    start = time.perf_counter()
    acct = ACCOUNTS.get(body.user_id)
    if not acct:
        raise HTTPException(404, "unknown user")
    if body.freeze_card:
        acct["card_frozen"] = True
    if body.freeze_upi:
        acct["upi_frozen"] = True
    if body.revoke_sessions:
        acct["sessions"] = 0
    return {
        "user_id": body.user_id,
        "card_frozen": acct["card_frozen"],
        "upi_frozen": acct["upi_frozen"],
        "active_sessions": acct["sessions"],
        "elapsed_ms": round((time.perf_counter() - start) * 1000, 2),
    }


@router.get("/account/{user_id}")
def account(user_id: str):
    acct = ACCOUNTS.get(user_id)
    if not acct:
        raise HTTPException(404, "unknown user")
    return {"user_id": user_id, **acct}
