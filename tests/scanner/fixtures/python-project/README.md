# TaskFlow API

A task management API built with FastAPI and SQLAlchemy.

## Tech Stack

- FastAPI 0.111
- SQLAlchemy 2.0 (async)
- PostgreSQL 16
- Alembic for migrations
- Pydantic v2 for validation

## Quick Start

```bash
pip install -e ".[dev]"
uvicorn src.main:app --reload
```

## Running Tests

```bash
pytest
pytest --cov=src
```

## Database Migrations

```bash
alembic upgrade head
alembic revision --autogenerate -m "description"
```

## API Documentation

Once running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Docker

```bash
docker build -t taskflow .
docker run -p 8000:8000 taskflow
```

## License

MIT
