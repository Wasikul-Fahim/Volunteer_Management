"""SQLAlchemy 2.0 database setup."""

from collections.abc import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from app.core.config import settings

engine = create_engine(settings.db_url, pool_pre_ping=True)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False, class_=Session)


class Base(DeclarativeBase):
    """Base class for all SQLAlchemy models."""



def get_db() -> Generator[Session, None, None]:
    """Yield a database session and always close it after the request."""

    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
