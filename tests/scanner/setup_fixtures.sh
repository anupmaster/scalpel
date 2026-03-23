#!/usr/bin/env bash
set -euo pipefail

# setup_fixtures.sh — Initialize git repositories in each fixture directory.
# Must be run before run_tests.sh to create the .git histories the scanner needs.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FIXTURES_DIR="${SCRIPT_DIR}/fixtures"

echo "=== Setting up fixture git repositories ==="

# --------------------------------------------------------------------------
# Helper: create a commit with a specific date
# --------------------------------------------------------------------------
make_commit() {
    local msg="$1"
    local date="$2"
    GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date" \
        git commit --allow-empty-message -m "$msg" --allow-empty 2>/dev/null || \
    GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date" \
        git commit -m "$msg" 2>/dev/null
}

# --------------------------------------------------------------------------
# Fixture 1: nextjs-project — well-maintained, 10+ realistic commits
# --------------------------------------------------------------------------
setup_nextjs() {
    local dir="${FIXTURES_DIR}/nextjs-project"
    echo "  [1/3] nextjs-project..."

    # Clean any previous .git
    rm -rf "${dir}/.git"
    cd "$dir"

    git init -q
    git checkout -q -b main 2>/dev/null || true

    # Commit 1 — project init
    git add package.json tsconfig.json next.config.js .gitignore
    make_commit "chore: initialize Next.js 14 project with TypeScript" "2024-05-01T09:00:00"

    # Commit 2 — prisma schema
    git add prisma/
    make_commit "feat: add Prisma schema with User, Product, Order models" "2024-05-03T14:30:00"

    # Commit 3 — app layout and home page
    git add src/app/layout.tsx src/app/page.tsx
    make_commit "feat: add root layout and home page with product grid" "2024-05-06T11:00:00"

    # Commit 4 — API route
    git add src/app/api/
    make_commit "feat: add products API with pagination and filtering" "2024-05-08T16:45:00"

    # Commit 5 — Button component
    git add src/components/
    make_commit "feat: add reusable Button component with variants" "2024-05-10T10:15:00"

    # Commit 6 — linting and formatting
    git add .eslintrc.json .prettierrc
    make_commit "chore: configure ESLint and Prettier" "2024-05-12T09:30:00"

    # Commit 7 — CI pipeline
    git add .github/
    make_commit "ci: add GitHub Actions workflow for lint, test, build" "2024-05-14T13:00:00"

    # Commit 8 — husky hooks
    git add .husky/
    make_commit "chore: add Husky pre-commit hook with lint-staged" "2024-05-15T08:00:00"

    # Commit 9 — tests
    git add src/__tests__/ vitest.config.ts
    make_commit "test: add Button and API route tests with Vitest" "2024-05-18T15:30:00"

    # Commit 10 — docs and env
    git add README.md .env.example
    make_commit "docs: add README and .env.example with all required vars" "2024-05-20T10:00:00"

    # Commit 11 — catch any remaining files
    git add -A
    make_commit "chore: add remaining project configuration files" "2024-05-22T12:00:00"

    echo "    -> $(git log --oneline | wc -l | tr -d ' ') commits created"
}

# --------------------------------------------------------------------------
# Fixture 2: python-project — medium quality, 5+ commits
# --------------------------------------------------------------------------
setup_python() {
    local dir="${FIXTURES_DIR}/python-project"
    echo "  [2/3] python-project..."

    rm -rf "${dir}/.git"
    cd "$dir"

    git init -q
    git checkout -q -b main 2>/dev/null || true

    # Commit 1 — project init
    git add pyproject.toml requirements.txt .gitignore alembic.ini
    make_commit "chore: initialize FastAPI project with dependencies" "2024-06-01T10:00:00"

    # Commit 2 — models and migrations
    git add src/models.py src/__init__.py alembic/
    make_commit "feat: add User and Task models with initial migration" "2024-06-05T14:00:00"

    # Commit 3 — main app and routes
    git add src/main.py src/routes/
    make_commit "feat: add FastAPI app with user routes" "2024-06-10T11:30:00"

    # Commit 4 — tests
    git add tests/
    make_commit "test: add tests for main app and user routes" "2024-06-15T16:00:00"

    # Commit 5 — CI and Docker
    git add .github/ Dockerfile
    make_commit "ci: add GitHub Actions test workflow and Dockerfile" "2024-06-20T09:00:00"

    # Commit 6 — docs and remaining
    git add -A
    make_commit "docs: add README with setup instructions" "2024-06-22T13:00:00"

    echo "    -> $(git log --oneline | wc -l | tr -d ' ') commits created"
}

# --------------------------------------------------------------------------
# Fixture 3: empty-repo — bare minimum, 1 commit
# --------------------------------------------------------------------------
setup_empty() {
    local dir="${FIXTURES_DIR}/empty-repo"
    echo "  [3/3] empty-repo..."

    rm -rf "${dir}/.git"
    cd "$dir"

    git init -q
    git checkout -q -b main 2>/dev/null || true

    git add -A
    make_commit "initial commit" "2024-07-01T10:00:00"

    echo "    -> $(git log --oneline | wc -l | tr -d ' ') commits created"
}

# --------------------------------------------------------------------------
# Run all setups
# --------------------------------------------------------------------------
setup_nextjs
setup_python
setup_empty

echo ""
echo "=== All fixtures initialized ==="
