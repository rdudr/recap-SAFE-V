from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1 import alert, recovery, score, stepup, totp, verify
from app.mocks import core_bank, demo_driver, integrity, sim_swap, telco

app = FastAPI(
    title="SAFE-V Trust Engine",
    version="0.1.0",
    description="Risk-based Identity Trust engine — BOB Hackathon 2026 prototype. "
    "Mock rails (CAMARA SIM-swap, telco, integrity) are simulated with real API shapes.",
)
app.add_middleware(
    CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"]
)

for r in (score.router, verify.router, stepup.router, alert.router, totp.router, recovery.router):
    app.include_router(r, prefix="/v1")

# Mock rails — real API shapes, simulated data. Never presented as live signals.
for r in (sim_swap.router, telco.router, integrity.router, core_bank.router, demo_driver.router):
    app.include_router(r)


@app.get("/health")
def health():
    return {"status": "ok", "service": "safe-v-trust-engine"}
