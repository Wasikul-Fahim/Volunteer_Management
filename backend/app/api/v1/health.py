"""Service health endpoint."""

from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from app.core.database import get_db

router = APIRouter(tags=["health"])


@router.get("/health")
def health(db: Session = Depends(get_db)) -> dict[str, str]:  # noqa: B008
    """Report API availability and whether the configured database responds."""

    try:
        db.execute(text("SELECT 1"))
    except SQLAlchemyError:
        return {"status": "ok", "db": "down"}

    return {"status": "ok", "db": "up"}
