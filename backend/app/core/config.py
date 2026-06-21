from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_name: str = "SAFE-V Trust Engine"
    db_url: str = "sqlite:///./data/safev.db"
    # Response ladder thresholds (tune on synthetic data, day 24-25)
    block_threshold: int = 70
    stepup_threshold: int = 40
    # Probation policy after a step-up recovery (mirrors NPCI ecosystem risk rule)
    probation_hours: int = 24
    probation_cap_inr: int = 5000
    # SIM-swap veto window
    sim_swap_veto_hours: int = 72


settings = Settings()
