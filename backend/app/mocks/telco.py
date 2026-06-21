"""Mock telco signals.

Call forwarding: labelled 'future CAMARA Call Forwarding Signal API' — NOT live in
India. The real-world mitigation is DoT's suspension of USSD (*401#) forwarding
since 15 Apr 2024. We keep the risk rule and simulate the signal.
"""

from fastapi import APIRouter

from app.mocks.state import state

router = APIRouter(prefix="/telco", tags=["mock-telco"])


@router.get("/call-forwarding")
def call_forwarding():
    return {
        "callForwardingActive": state.call_forwarding_active,
        "_note": "SIMULATED — future CAMARA API, not live in India",
    }
