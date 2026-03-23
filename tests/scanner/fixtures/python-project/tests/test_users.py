"""Tests for user management routes."""

import pytest
from httpx import ASGITransport, AsyncClient

from src.main import app


@pytest.fixture
async def client():
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://testserver",
    ) as ac:
        yield ac


async def test_create_user(client: AsyncClient):
    """Creating a user returns 201 with user data."""
    payload = {
        "email": "alice@example.com",
        "username": "alice",
        "password": "securepass123",
        "full_name": "Alice Johnson",
    }
    response = await client.post("/api/v1/users", json=payload)
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "alice@example.com"
    assert data["username"] == "alice"
    assert "id" in data
    # Password should never be in the response
    assert "password" not in data
    assert "hashed_password" not in data


async def test_create_user_invalid_email(client: AsyncClient):
    """Invalid email format returns 422."""
    payload = {
        "email": "not-an-email",
        "username": "bob",
        "password": "securepass123",
    }
    response = await client.post("/api/v1/users", json=payload)
    assert response.status_code == 422


async def test_create_user_short_password(client: AsyncClient):
    """Password shorter than 8 chars returns 422."""
    payload = {
        "email": "charlie@example.com",
        "username": "charlie",
        "password": "short",
    }
    response = await client.post("/api/v1/users", json=payload)
    assert response.status_code == 422


async def test_get_user_not_implemented(client: AsyncClient):
    """Get user endpoint returns 501 (stub)."""
    response = await client.get("/api/v1/users/some-uuid")
    assert response.status_code == 501


async def test_list_users_empty(client: AsyncClient):
    """List users returns empty list when no users exist."""
    response = await client.get("/api/v1/users")
    assert response.status_code == 200
    assert response.json() == []
