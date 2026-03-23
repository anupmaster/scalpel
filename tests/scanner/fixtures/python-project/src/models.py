"""SQLAlchemy ORM models for TaskFlow."""

from datetime import datetime
from typing import Optional
from uuid import uuid4

from sqlalchemy import (
    Boolean,
    DateTime,
    Enum,
    ForeignKey,
    Integer,
    String,
    Text,
    func,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship

# TODO: Add soft delete mixin for all models
# TODO: Add created_by / updated_by audit columns
# TODO: Consider using timestamptz instead of timestamp


class Base(DeclarativeBase):
    """Base class for all ORM models."""
    pass


class User(Base):
    """Represents a registered user in the system."""

    __tablename__ = "users"

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    username: Mapped[str] = mapped_column(String(50), unique=True, index=True)
    hashed_password: Mapped[str] = mapped_column(String(255))
    full_name: Mapped[Optional[str]] = mapped_column(String(100))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_superuser: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, server_default=func.now(), onupdate=func.now()
    )

    # TODO: Add avatar_url field
    # TODO: Add last_login_at tracking

    tasks: Mapped[list["Task"]] = relationship(back_populates="assignee", lazy="selectin")

    def __repr__(self) -> str:
        return f"<User {self.username}>"


class Task(Base):
    """Represents a task that can be assigned to a user."""

    __tablename__ = "tasks"

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    title: Mapped[str] = mapped_column(String(200))
    description: Mapped[Optional[str]] = mapped_column(Text)
    status: Mapped[str] = mapped_column(
        Enum("todo", "in_progress", "review", "done", name="task_status"),
        default="todo",
    )
    priority: Mapped[int] = mapped_column(Integer, default=0)
    assignee_id: Mapped[Optional[str]] = mapped_column(
        UUID(as_uuid=False), ForeignKey("users.id"), nullable=True
    )
    due_date: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, server_default=func.now(), onupdate=func.now()
    )

    # TODO: Add labels/tags support (many-to-many)
    # TODO: Add estimated_hours field for sprint planning
    # TODO: Add parent_task_id for subtask support

    assignee: Mapped[Optional["User"]] = relationship(back_populates="tasks")

    def __repr__(self) -> str:
        return f"<Task {self.title[:30]}>"
