"""ML anomaly layer: IsolationForest over per-persona behavioral baselines.

Prototype approach: one global model trained at startup on synthetic data
(cold-start answer: global model + per-user warm-up window).
Day 24-25: per-persona models + SHAP explanations (see explain.py).
"""

import numpy as np
from sklearn.ensemble import IsolationForest

from app.data.generator import baseline_frame

FEATURES = [
    "amount_pctl",        # amount percentile vs user baseline
    "hour",               # hour of day
    "geo_km",             # distance from usual location
    "device_age_days",    # how long we've known this device
    "payee_age_days",     # how long the payee has existed
    "typing_z",           # typing-cadence z-score vs enrolled baseline
    "recovery_recency_h", # hours since last recovery event
]

_model: IsolationForest | None = None


def _get_model() -> IsolationForest:
    global _model
    if _model is None:
        df = baseline_frame()
        _model = IsolationForest(n_estimators=200, contamination=0.02, random_state=42)
        _model.fit(df[FEATURES].to_numpy())
    return _model


def anomaly_score(ev: dict) -> float:
    """Return 0-100 (higher = more anomalous)."""
    x = np.array([[float(ev.get(f, 0.0)) for f in FEATURES]])
    raw = _get_model().score_samples(x)[0]  # higher = more normal, typically [-0.7, -0.3]
    scaled = np.clip((-raw - 0.3) / 0.4, 0.0, 1.0)
    return round(float(scaled) * 100, 1)


def feature_vector(ev: dict) -> dict:
    return {f: float(ev.get(f, 0.0)) for f in FEATURES}
