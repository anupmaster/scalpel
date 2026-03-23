"""Add labels table and task_labels junction table.

Revision ID: f6e5d4c3b2a1
Revises: a1b2c3d4e5f6
Create Date: 2024-06-15 14:30:00.000000
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID

revision: str = "f6e5d4c3b2a1"
down_revision: Union[str, None] = "a1b2c3d4e5f6"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "labels",
        sa.Column("id", UUID(as_uuid=False), primary_key=True),
        sa.Column("name", sa.String(50), unique=True, nullable=False),
        sa.Column("color", sa.String(7), default="#6366f1"),
        sa.Column("created_at", sa.DateTime(), server_default=sa.func.now()),
    )

    op.create_table(
        "task_labels",
        sa.Column("task_id", UUID(as_uuid=False), sa.ForeignKey("tasks.id", ondelete="CASCADE"), primary_key=True),
        sa.Column("label_id", UUID(as_uuid=False), sa.ForeignKey("labels.id", ondelete="CASCADE"), primary_key=True),
    )


def downgrade() -> None:
    op.drop_table("task_labels")
    op.drop_table("labels")
