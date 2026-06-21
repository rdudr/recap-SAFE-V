"""Mock Play Integrity verdict (real API needs a Play-signed app + Cloud project;
an emulator would fail a real MEETS_DEVICE_INTEGRITY check — hence the mock)."""

from fastapi import APIRouter

from app.mocks.state import state

router = APIRouter(prefix="/integrity", tags=["mock-integrity"])


@router.post("/verdict")
def verdict():
    labels = ["MEETS_BASIC_INTEGRITY"]
    if state.device_integrity:
        labels.append("MEETS_DEVICE_INTEGRITY")
    return {"deviceIntegrity": {"deviceRecognitionVerdict": labels}}
