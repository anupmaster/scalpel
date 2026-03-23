"""User management routes."""

from datetime import timedelta
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, EmailStr, Field

# TODO: Import actual database session dependency
# TODO: Import auth utilities for JWT token creation

router = APIRouter(tags=["users"])


class UserCreate(BaseModel):
    """Schema for creating a new user."""

    email: EmailStr
    username: str = Field(min_length=3, max_length=50, pattern=r"^[a-zA-Z0-9_-]+$")
    password: str = Field(min_length=8, max_length=128)
    full_name: str | None = None


class UserResponse(BaseModel):
    """Schema for user responses (excludes sensitive fields)."""

    id: str
    email: str
    username: str
    full_name: str | None
    is_active: bool

    model_config = {"from_attributes": True}


class TokenResponse(BaseModel):
    """Schema for authentication token responses."""

    access_token: str
    token_type: str = "bearer"
    expires_in: int


# TODO: Replace stub implementations with real database calls
# TODO: Add email verification flow
# TODO: Add password reset endpoint


@router.post("/users", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(payload: UserCreate) -> UserResponse:
    """Register a new user account."""
    # TODO: Check for existing user with same email or username
    # TODO: Hash the password with passlib
    # TODO: Store in database
    # FIXME: This is a stub — returns fake data for API contract testing
    return UserResponse(
        id="stub-uuid-001",
        email=payload.email,
        username=payload.username,
        full_name=payload.full_name,
        is_active=True,
    )


@router.get("/users/{user_id}", response_model=UserResponse)
async def get_user(user_id: str) -> UserResponse:
    """Retrieve a user by their ID."""
    # TODO: Fetch from database
    # TODO: Add authorization check — users can only view their own profile or admin
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Not implemented yet",
    )


@router.get("/users", response_model=list[UserResponse])
async def list_users(skip: int = 0, limit: int = 20) -> list[UserResponse]:
    """List all users with pagination."""
    # TODO: Implement with actual database query
    # TODO: Add filtering by is_active, search by name/email
    return []


@router.post("/auth/login", response_model=TokenResponse)
async def login(email: str, password: str) -> TokenResponse:
    """Authenticate a user and return a JWT token."""
    # TODO: Validate credentials against database
    # TODO: Generate JWT with python-jose
    # FIXME: Hardcoded stub token for development
    return TokenResponse(
        access_token="stub.jwt.token",
        expires_in=3600,
    )
