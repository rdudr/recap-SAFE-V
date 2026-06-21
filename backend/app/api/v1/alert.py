"""POST /v1/alert — SOC alerts (high-risk events, kill-switch usage, insider rules)."""

from datetime import datetime, timezone

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(tags=["trust-engine"])

ALERTS: list[dict] = []


class Alert(BaseModel):
    severity: str  # info | warning | critical
    source: str    # engine | killswitch | insider
    message: str
    user_id: str | None = None


@router.post("/alert")
def create_alert(body: Alert):
    alert = {**body.model_dump(), "ts": datetime.now(timezone.utc).isoformat()}
    ALERTS.append(alert)
    return alert


@router.get("/alerts")
def list_alerts(limit: int = 50):
    return ALERTS[-limit:][::-1]
