"""Tests for the Phase 0 health endpoint."""


def test_health_reports_api_and_database_status(client) -> None:
    response = client.get("/api/v1/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok", "db": "up"}
