"""Demo-driver panel: one endpoint to flip scenario toggles live on stage.

POST /demo/scenario/s1  -> SIM-swap ATO        (expect BLOCK)
POST /demo/scenario/s2  -> abroad + TOTP        (expect STEP_UP -> TOTP -> ALLOW)
POST /demo/scenario/s2b -> new-phone recovery   (expect STEP_UP -> probation)
POST /demo/scenario/s3  -> legit user           (expect ALLOW)
POST /demo/reset        -> back to clean state
"""

from fastapi import APIRouter, HTTPException

from app.mocks.state import DemoState, state

router = APIRouter(prefix="/demo", tags=["demo-driver"])

SCENARIOS: dict[str, dict] = {
    "s1": {"sim_swap_hours_ago": 6, "call_forwarding_active": True},
    "s2": {"abroad": True, "travel_declared": True},
    "s2b": {"abroad": True, "travel_declared": False},
    "s3": {},
}


@router.post("/scenario/{name}")
def set_scenario(name: str):
    if name not in SCENARIOS:
        raise HTTPException(404, f"unknown scenario: {name}")
    _apply(DemoState(**SCENARIOS[name]))
    return {"scenario": name, "state": state}


@router.post("/reset")
def reset():
    _apply(DemoState())
    return {"state": state}


@router.get("/state")
def get_state():
    return state


@router.post("/state")
def set_state(new: DemoState):
    _apply(new)
    return state


def _apply(new: DemoState) -> None:
    for field, value in new.model_dump().items():
        setattr(state, field, value)
