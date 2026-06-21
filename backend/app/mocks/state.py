"""Shared demo state — the demo-driver panel flips these toggles live on stage.

Everything here is SIMULATED. Each field maps to a real production rail
(see feasibility_research.md) and the mock endpoints expose the real API shapes.
"""

from pydantic import BaseModel


class DemoState(BaseModel):
    # CAMARA SIM Swap API (launched by Jio/Airtel/Vi, Oct 2025 — enterprise-gated)
    sim_swap_hours_ago: float | None = None  # None = no recent swap
    # Future CAMARA Call Forwarding Signal — NOT live in India (DoT killed *401# Apr 2024)
    call_forwarding_active: bool = False
    # Play Integrity verdict (real API needs a Play-signed app; mocked here)
    device_integrity: bool = True
    # Native-SDK capability in production (browser/demo cannot detect AnyDesk)
    screen_share_active: bool = False
    # Geo context for the session
    abroad: bool = False
    travel_declared: bool = False


state = DemoState()
