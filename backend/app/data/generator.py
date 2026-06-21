"""Synthetic data: persona baselines for IsolationForest training + mule-ring topology.

Personas (extend day 21-23 with Rahul's realism review):
  priya          — salaried, Mumbai, daytime UPI, small amounts
  rahul_nri      — NRI, declared travel windows, evening IST usage
  attacker_target— dormant account, the S1 victim
"""

import numpy as np
import pandas as pd

RNG = np.random.default_rng(42)


def baseline_frame(n_per_persona: int = 500) -> pd.DataFrame:
    """Normal-behavior rows used to train the global IsolationForest."""
    frames = []
    for _persona, (amount_mu, hour_mu, geo_mu) in {
        "priya": (45, 13, 4),
        "rahul_nri": (60, 20, 12),
        "attacker_target": (30, 11, 3),
    }.items():
        n = n_per_persona
        frames.append(
            pd.DataFrame(
                {
                    "amount_pctl": np.clip(RNG.normal(amount_mu, 18, n), 0, 100),
                    "hour": np.clip(RNG.normal(hour_mu, 3, n), 0, 23),
                    "geo_km": np.abs(RNG.normal(geo_mu, 8, n)),
                    "device_age_days": np.abs(RNG.normal(220, 120, n)),
                    "payee_age_days": np.abs(RNG.normal(100, 70, n)),
                    "typing_z": RNG.normal(0, 0.6, n),
                    "recovery_recency_h": np.abs(RNG.normal(600, 300, n)),
                }
            )
        )
    return pd.concat(frames, ignore_index=True)


def mule_graph_edges(n_accounts: int = 200, n_rings: int = 3) -> list[tuple[str, str, str]]:
    """(account, account, shared_attribute) edges — rings share device IDs / IPs.

    Feed to networkx: hub accounts fall out of connected components + degree.
    """
    edges: list[tuple[str, str, str]] = []
    accounts = [f"acct_{i:03d}" for i in range(n_accounts)]
    for ring in range(n_rings):
        members = RNG.choice(accounts, size=RNG.integers(6, 12), replace=False)
        shared = f"device_ring{ring}" if ring % 2 == 0 else f"ip_ring{ring}"
        hub = members[0]
        for m in members[1:]:
            edges.append((hub, str(m), shared))
    # benign noise: occasional shared home IPs (families)
    for _ in range(20):
        a, b = RNG.choice(accounts, size=2, replace=False)
        edges.append((str(a), str(b), "ip_home"))
    return edges
