# SAFE-V — Identity Trust, Protection & Safety

Prototype for **BOB Hackathon 2026** (IIT Gandhinagar, PSB Hackathon Series).
Risk-based Trust Engine: every sensitive banking event is scored 0–100 → **Allow / Step-Up / Block**, with per-decision explanations. Headline feature: **offline TOTP for NRI/travel users** — the bank app is the authenticator; codes work in airplane mode.

Docs live one level up: `../specs.md` (build plan), `../feasibility_research.md` (what's real vs mocked), `../future.md` (roadmap).

## Run it

```bash
# 1. Backend (Trust Engine + mock rails)
cd backend
venv\Scripts\activate          # created already; else: python -m venv venv && pip install -r requirements.txt
uvicorn app.main:app --reload  # Swagger: http://localhost:8000/docs

# 2. Flutter app (emulator talks to backend via 10.0.2.2)
cd ../app_flutter
flutter run
```

## Drive the demo

```bash
curl -X POST localhost:8000/demo/scenario/s1   # SIM-swap ATO      -> BLOCK
curl -X POST localhost:8000/demo/scenario/s2   # abroad + TOTP     -> STEP_UP -> TOTP -> ALLOW
curl -X POST localhost:8000/demo/scenario/s2b  # new-phone recovery-> STEP_UP -> probation
curl -X POST localhost:8000/demo/scenario/s3   # legit user        -> ALLOW
curl -X POST localhost:8000/demo/reset
```

Then act in the app (login / pay / recover) and watch `/v1/events` (SOC feed).

## Honesty rule

Mock rails (`/sim-swap/*`, `/telco/*`, `/integrity/*`) use **real API shapes with simulated data** — CAMARA SIM Swap (launched by Jio/Airtel/Vi, Oct 2025), Play Integrity, future call-forwarding signal. On stage we always say "simulated here; production rail is X." Full Say-Never list: `../specs.md` §8.

## Team

Rishabh Dangi (Flutter/UI) · Gajendra Teli (Python/ML) · Rahul Patel (finance & domain)
