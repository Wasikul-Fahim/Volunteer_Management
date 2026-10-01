"""Application settings loaded from environment variables."""

from functools import cached_property

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Runtime configuration for the API and future application services."""

    db_url: str = "mysql+pymysql://volunteer:volunteer_password@localhost:3306/volunteer_platform"
    secret_key: str = "change-me-in-.env"
    access_token_expire_minutes: int = 30
    refresh_token_expire_days: int = 7
    cors_origins: str = "http://localhost:5173"

    matching_skills_weight: float = Field(default=0.45, ge=0, le=1)
    matching_interest_weight: float = Field(default=0.20, ge=0, le=1)
    matching_location_weight: float = Field(default=0.20, ge=0, le=1)
    matching_availability_weight: float = Field(default=0.15, ge=0, le=1)

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    @cached_property
    def cors_origins_list(self) -> list[str]:
        """Return comma-separated CORS origins in middleware-friendly form."""

        return [origin.strip() for origin in self.cors_origins.split(",") if origin.strip()]


settings = Settings()
