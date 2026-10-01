"""Shared test configuration for the backend."""

from collections.abc import Generator

import pytest
from fastapi.testclient import TestClient

from app.core.database import get_db
from app.main import app


class FakeSession:
    """Minimal session double used to keep health tests database-independent."""

    def execute(self, statement: object) -> None:
        return None

    def close(self) -> None:
        return None


@pytest.fixture
def client() -> Generator[TestClient, None, None]:
    app.dependency_overrides[get_db] = lambda: FakeSession()
    try:
        with TestClient(app) as test_client:
            yield test_client
    finally:
        app.dependency_overrides.clear()
