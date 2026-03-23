"""TaskFlow API — Main application entry point."""

from contextlib import asynccontextmanager
from typing import AsyncGenerator

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from src.routes.users import router as users_router

# TODO: Add rate limiting middleware
# TODO: Add request ID middleware for tracing
# TODO: Configure structured logging with structlog
# TODO: Add health check endpoint for k8s probes


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    """Handle startup and shutdown events."""
    # TODO: Initialize database connection pool on startup
    # TODO: Run pending migrations on startup (optional, behind flag)
    print("Starting TaskFlow API...")
    yield
    print("Shutting down TaskFlow API...")
    # TODO: Close database connections gracefully


app = FastAPI(
    title="TaskFlow API",
    description="Task management API with user authentication and team collaboration.",
    version="0.8.2",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "https://taskflow.io"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users_router, prefix="/api/v1")

# TODO: Add tasks router
# TODO: Add teams router
# TODO: Add WebSocket endpoint for real-time task updates


@app.get("/")
async def root():
    """Root endpoint returning API information."""
    return {
        "name": "TaskFlow API",
        "version": "0.8.2",
        "docs": "/docs",
    }


@app.get("/healthz")
async def healthz():
    # TODO: Actually check database connectivity here
    return {"status": "ok"}
