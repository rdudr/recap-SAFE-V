"""Per-decision explainability: top contributing signals.

Prototype: rule hits ranked first, then largest feature deviations from the
synthetic-baseline means. Day 24-25 upgrade: SHAP TreeExplainer on the
IsolationForest (precompute if latency bites).
"""

from app.engine import ml

# Rough baseline means of the synthetic data (regenerate when generator changes)
_BASELINE_MEANS = {
    "amount_pctl": 50.0,
    "hour": 14.0,
    "geo_km": 5.0,
    "device_age_days": 200.0,
    "payee_age_days": 90.0,
    "typing_z": 0.0,
    "recovery_recency_h": 500.0,
}
_BASELINE_SCALE = {
    "amount_pctl": 30.0,
    "hour": 6.0,
    "geo_km": 50.0,
    "device_age_days": 150.0,
    "payee_age_days": 80.0,
    "typing_z": 1.0,
    "recovery_recency_h": 400.0,
}


def top_signals(ev: dict, hits: list, ml_score: float, n: int = 3) -> list[dict]:
    signals = [
        {"signal": h.rule, "kind": "rule", "detail": h.reason} for h in hits
    ]
    feats = ml.feature_vector(ev)
    deviations = sorted(
        (
            {
                "signal": name,
                "kind": "feature",
                "detail": f"{name}={value:.1f} (baseline ~{_BASELINE_MEANS[name]:.0f})",
                "_dev": abs(value - _BASELINE_MEANS[name]) / _BASELINE_SCALE[name],
            }
            for name, value in feats.items()
        ),
        key=lambda d: d["_dev"],
        reverse=True,
    )
    for d in deviations:
        d.pop("_dev")
    return (signals + deviations)[:n]
