"""Tests for the main FastAPI application."""

import pytest
from httpx import ASGITransport, AsyncClient

from src.main import app


@pytest.fixture
async def client():
    """Create an async HTTP client for testing."""
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://testserver",
    ) as ac:
        yield ac


async def test_root_endpoint(client: AsyncClient):
    """Root endpoint returns API info."""
    response = await client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "TaskFlow API"
    assert "version" in data


async def test_health_check(client: AsyncClient):
    """Health check endpoint returns ok status."""
    response = await client.get("/healthz")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


async def test_openapi_docs_available(client: AsyncClient):
    """OpenAPI docs should be served at /docs."""
    response = await client.get("/docs")
    assert response.status_code == 200


async def test_cors_headers(client: AsyncClient):
    """CORS middleware allows configured origins."""
    response = await client.options(
        "/",
        headers={
            "Origin": "http://localhost:3000",
            "Access-Control-Request-Method": "GET",
        },
    )
    assert response.status_code == 200
    assert "access-control-allow-origin" in response.headers
