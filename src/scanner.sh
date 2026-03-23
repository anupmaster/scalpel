#!/usr/bin/env bash
set -uo pipefail

# Scalpel Scanner v2.0 — 12-Dimension Codebase Health Diagnostic
# Pure bash. Zero AI. Zero external dependencies beyond standard Unix tools.
# Copyright (c) 2026 Anup Karanjkar (@anupmaster) — MIT License
# https://github.com/anupmaster/scalpel

SCANNER_VERSION="2.0"
PROJECT_DIR=""
OUTPUT_MODE="pretty"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
for arg in "$@"; do
  case "$arg" in
    --json)       OUTPUT_MODE="json" ;;
    --ci)         OUTPUT_MODE="ci" ;;
    --markdown)   OUTPUT_MODE="markdown" ;;
    --score-only) OUTPUT_MODE="score" ;;
    --help|-h)
      cat <<'USAGE'
Scalpel Scanner v2.0 — Codebase Health Diagnostic

Usage: scanner.sh [directory] [options]

Options:
  --json          Machine-readable JSON output
  --ci            GitHub Actions annotation format
  --markdown      Markdown report (for PR comments)
  --score-only    Print only the numeric health score
  --help, -h      Show this help message

Examples:
  ./scanner.sh                    # Scan current directory, pretty output
  ./scanner.sh /path/to/project   # Scan specific directory
  ./scanner.sh --json             # JSON output for current directory
  ./scanner.sh /app --ci          # CI annotations for /app
USAGE
      exit 0
      ;;
    -*)
      echo "Unknown option: $arg (try --help)" >&2
      exit 1
      ;;
    *)
      if [ -d "$arg" ]; then
        PROJECT_DIR="$arg"
      fi
      ;;
  esac
done

[ -z "$PROJECT_DIR" ] && PROJECT_DIR="."

# Resolve to absolute path
PROJECT_DIR="$(cd "$PROJECT_DIR" 2>/dev/null && pwd)" || {
  echo "Error: directory not found" >&2; exit 1
}

# ---------------------------------------------------------------------------
# Utility helpers
# ---------------------------------------------------------------------------
_has_cmd() { command -v "$1" >/dev/null 2>&1; }
_file_exists() { [ -f "$PROJECT_DIR/$1" ]; }
_dir_exists() { [ -d "$PROJECT_DIR/$1" ]; }

_count_files() {
  local pattern="$1"
  find "$PROJECT_DIR" -maxdepth 8 -name "$pattern" -not -path '*/node_modules/*' \
    -not -path '*/.git/*' -not -path '*/vendor/*' -not -path '*/.next/*' \
    -not -path '*/dist/*' -not -path '*/build/*' -not -path '*/__pycache__/*' \
    2>/dev/null | wc -l | tr -d ' '
}

_dir_size_mb() {
  if [ -d "$PROJECT_DIR/$1" ]; then
    du -sm "$PROJECT_DIR/$1" 2>/dev/null | awk '{print $1}' || echo "0"
  else
    echo "0"
  fi
}

_git() { git -C "$PROJECT_DIR" "$@" 2>/dev/null || true; }
_is_git() { [ -d "$PROJECT_DIR/.git" ] || git -C "$PROJECT_DIR" rev-parse --git-dir >/dev/null 2>&1; }

_read_json_field() {
  local file="$1" key="$2"
  sed -n "s/.*\"${key}\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$file" 2>/dev/null | head -1
}

# Safe grep count: returns count of matching lines, 0 if none
_grep_count() {
  grep "$@" 2>/dev/null | wc -l | tr -d ' '
}

# Safe grep -c with fallback
_grep_c() {
  grep -c "$@" 2>/dev/null || echo "0"
}

# ---------------------------------------------------------------------------
# Result storage (plain variables — bash 3.2 compat, no associative arrays)
# ---------------------------------------------------------------------------
R_NAME="" R_FRAMEWORK="" R_LANGUAGE="" R_STYLING="" R_ORM=""
R_DB_TYPE="" R_DB_TABLES=0 R_AUTH=""
R_DEPLOY="" R_CI_TOOL=""
R_DEP_COUNT=0 R_IS_MONOREPO="false"
R_FILE_COUNTS="" R_USE_CLIENT=0 R_ROUTER_TYPE=""
R_COMMIT_COUNT=0 R_BRANCH_COUNT=0 R_CONTRIBUTOR_COUNT=0 R_STASH_COUNT=0 R_DELETED_FILES=0
R_HAS_DOCKER="false" R_HAS_CI="false" R_CI_FILES=""
R_MIGRATION_COUNT=0
R_TEST_COUNT=0 R_TEST_RUNNER="" R_HAS_COVERAGE="false"
R_SECRET_HITS=0 R_ENV_UNIGNORED="false" R_SECURITY_ISSUES=0
R_HAS_ESLINT="false" R_HAS_PRETTIER="false" R_HAS_HUSKY="false"
R_TS_STRICT="false" R_TODO_COUNT=0 R_FIXME_COUNT=0 R_HACK_COUNT=0
R_NODE_MODULES_MB=0 R_DIST_MB=0
R_README_LINES=0 R_HAS_DOCS="false" R_JSDOC_COUNT=0
R_HAS_CLAUDE_MD="false" R_HAS_CURSORRULES="false" R_HAS_MCP="false"
R_HAS_LOCKFILE="false" R_AUDIT_AVAILABLE="false" R_AUDIT_VULNS=0
R_HAS_ENV_EXAMPLE="false"
R_ERROR_HANDLING=0
R_SRC_FILE_COUNT=0

# Health score components
H_SCORE=0 H_RATING=""
H_TEST_INFRA=0 H_TEST_COVERAGE=0 H_CICD=0 H_NO_SECRETS=0
H_TS_STRICT=0 H_LINT=0 H_FORMAT=0 H_PRECOMMIT=0
H_README=0 H_API_DOCS=0 H_JSDOC=0 H_GIT_HEALTH=0
H_NO_TODO=0 H_NO_DEAD=0 H_ERROR_HANDLING=0 H_ENV_DOC=0
H_DEPS=0 H_BUNDLE=0
H_PRIORITIES=""

# ---------------------------------------------------------------------------
# Dimension 1: Project DNA
# ---------------------------------------------------------------------------
scan_project_dna() {
  if _file_exists "package.json"; then
    R_NAME=$(_read_json_field "$PROJECT_DIR/package.json" "name")
  fi
  if [ -z "$R_NAME" ] && _file_exists "pyproject.toml"; then
    R_NAME=$(sed -n 's/^name[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' "$PROJECT_DIR/pyproject.toml" 2>/dev/null | head -1)
  fi
  if [ -z "$R_NAME" ] && _file_exists "Cargo.toml"; then
    R_NAME=$(sed -n 's/^name[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' "$PROJECT_DIR/Cargo.toml" 2>/dev/null | head -1)
  fi
  if [ -z "$R_NAME" ] && _file_exists "go.mod"; then
    R_NAME=$(head -1 "$PROJECT_DIR/go.mod" 2>/dev/null | awk '{print $2}')
  fi
  [ -z "$R_NAME" ] && R_NAME=$(basename "$PROJECT_DIR")

  # Framework detection from package.json
  if _file_exists "package.json"; then
    local pkg="$PROJECT_DIR/package.json"
    local deps
    deps=$(cat "$pkg" 2>/dev/null || true)
    if echo "$deps" | grep -q '"next"' 2>/dev/null; then R_FRAMEWORK="Next.js"
    elif echo "$deps" | grep -q '"nuxt"' 2>/dev/null; then R_FRAMEWORK="Nuxt"
    elif echo "$deps" | grep -q '"@angular/core"' 2>/dev/null; then R_FRAMEWORK="Angular"
    elif echo "$deps" | grep -q '"svelte"' 2>/dev/null; then R_FRAMEWORK="SvelteKit"
    elif echo "$deps" | grep -q '"react"' 2>/dev/null; then R_FRAMEWORK="React"
    elif echo "$deps" | grep -q '"vue"' 2>/dev/null; then R_FRAMEWORK="Vue"
    elif echo "$deps" | grep -q '"express"' 2>/dev/null; then R_FRAMEWORK="Express"
    elif echo "$deps" | grep -q '"fastify"' 2>/dev/null; then R_FRAMEWORK="Fastify"
    fi
    if echo "$deps" | grep -q '"typescript"' 2>/dev/null; then R_LANGUAGE="TypeScript"
    else R_LANGUAGE="JavaScript"; fi
    if echo "$deps" | grep -q '"tailwindcss"' 2>/dev/null; then R_STYLING="Tailwind"
    elif echo "$deps" | grep -q '"styled-components"' 2>/dev/null; then R_STYLING="styled-components"
    elif echo "$deps" | grep -q '"@emotion"' 2>/dev/null; then R_STYLING="Emotion"
    elif echo "$deps" | grep -q '"sass"' 2>/dev/null; then R_STYLING="Sass"
    else R_STYLING="CSS"; fi
    if echo "$deps" | grep -q '"prisma"' 2>/dev/null; then R_ORM="Prisma"
    elif echo "$deps" | grep -q '"drizzle-orm"' 2>/dev/null; then R_ORM="Drizzle"
    elif echo "$deps" | grep -q '"typeorm"' 2>/dev/null; then R_ORM="TypeORM"
    elif echo "$deps" | grep -q '"sequelize"' 2>/dev/null; then R_ORM="Sequelize"
    elif echo "$deps" | grep -q '"mongoose"' 2>/dev/null; then R_ORM="Mongoose"
    fi
    if echo "$deps" | grep -q '"next-auth"' 2>/dev/null; then R_AUTH="NextAuth"
    elif echo "$deps" | grep -q '"@clerk"' 2>/dev/null; then R_AUTH="Clerk"
    elif echo "$deps" | grep -q '"@auth0"' 2>/dev/null; then R_AUTH="Auth0"
    elif echo "$deps" | grep -q '"firebase"' 2>/dev/null; then R_AUTH="Firebase"
    elif echo "$deps" | grep -q '"passport"' 2>/dev/null; then R_AUTH="Passport"
    elif echo "$deps" | grep -q '"@supabase"' 2>/dev/null; then R_AUTH="Supabase"
    fi
    R_DEP_COUNT=$(_grep_c '"[^"]*"[[:space:]]*:[[:space:]]*"[~^>=<0-9]' "$pkg")
  elif _file_exists "pyproject.toml"; then
    R_LANGUAGE="Python"
    if grep -q 'django' "$PROJECT_DIR/pyproject.toml" 2>/dev/null; then R_FRAMEWORK="Django"
    elif grep -q 'fastapi' "$PROJECT_DIR/pyproject.toml" 2>/dev/null; then R_FRAMEWORK="FastAPI"
    elif grep -q 'flask' "$PROJECT_DIR/pyproject.toml" 2>/dev/null; then R_FRAMEWORK="Flask"
    fi
  elif _file_exists "Cargo.toml"; then
    R_LANGUAGE="Rust"
    if grep -q 'actix' "$PROJECT_DIR/Cargo.toml" 2>/dev/null; then R_FRAMEWORK="Actix"
    elif grep -q 'axum' "$PROJECT_DIR/Cargo.toml" 2>/dev/null; then R_FRAMEWORK="Axum"
    fi
  elif _file_exists "go.mod"; then
    R_LANGUAGE="Go"
    if grep -q 'gin-gonic' "$PROJECT_DIR/go.mod" 2>/dev/null; then R_FRAMEWORK="Gin"
    elif grep -q 'fiber' "$PROJECT_DIR/go.mod" 2>/dev/null; then R_FRAMEWORK="Fiber"
    fi
  fi

  # Monorepo detection
  if _file_exists "pnpm-workspace.yaml" || _file_exists "lerna.json" || _file_exists "nx.json" || _file_exists "turbo.json"; then
    R_IS_MONOREPO="true"
  fi
  [ -z "$R_FRAMEWORK" ] && R_FRAMEWORK="Unknown"
  [ -z "$R_LANGUAGE" ] && R_LANGUAGE="Unknown"
  [ -z "$R_STYLING" ] && R_STYLING="None"
  [ -z "$R_ORM" ] && R_ORM="None"
  [ -z "$R_AUTH" ] && R_AUTH="None"
}

# ---------------------------------------------------------------------------
# Dimension 2: Architecture
# ---------------------------------------------------------------------------
scan_architecture() {
  R_SRC_FILE_COUNT=$(find "$PROJECT_DIR" -maxdepth 8 -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.py" -o -name "*.rs" -o -name "*.go" \) \
    -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/vendor/*' \
    -not -path '*/.next/*' -not -path '*/dist/*' -not -path '*/build/*' \
    2>/dev/null | wc -l | tr -d ' ')

  if [ "$R_FRAMEWORK" = "Next.js" ]; then
    if _dir_exists "app" || _dir_exists "src/app"; then
      R_ROUTER_TYPE="App Router"
    elif _dir_exists "pages" || _dir_exists "src/pages"; then
      R_ROUTER_TYPE="Pages Router"
    fi
  fi

  R_USE_CLIENT=$(_grep_count -rl "'use client'\|\"use client\"" "$PROJECT_DIR" \
    --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx")
}

# ---------------------------------------------------------------------------
# Dimension 3: Git Forensics
# ---------------------------------------------------------------------------
scan_git() {
  _is_git || return 0
  R_COMMIT_COUNT=$(_git log --oneline | wc -l | tr -d ' ')
  R_BRANCH_COUNT=$(_git branch -a | wc -l | tr -d ' ')
  R_CONTRIBUTOR_COUNT=$(_git shortlog -sn --all | wc -l | tr -d ' ')
  R_STASH_COUNT=$(_git stash list | wc -l | tr -d ' ')
  R_DELETED_FILES=$(_grep_count -c 'delete mode' <<< "$(_git log --diff-filter=D --summary --all)")
}

# ---------------------------------------------------------------------------
# Dimension 4: Infrastructure
# ---------------------------------------------------------------------------
scan_infrastructure() {
  if _file_exists "Dockerfile" || _file_exists "docker-compose.yml" || _file_exists "docker-compose.yaml"; then
    R_HAS_DOCKER="true"
  fi
  if _dir_exists ".github/workflows"; then
    R_HAS_CI="true"; R_CI_TOOL="GitHub Actions"
  elif _file_exists ".gitlab-ci.yml"; then
    R_HAS_CI="true"; R_CI_TOOL="GitLab CI"
  elif _file_exists ".circleci/config.yml"; then
    R_HAS_CI="true"; R_CI_TOOL="CircleCI"
  elif _file_exists "Jenkinsfile"; then
    R_HAS_CI="true"; R_CI_TOOL="Jenkins"
  fi
  [ -z "$R_CI_TOOL" ] && R_CI_TOOL="None"
  if _file_exists "vercel.json" || _dir_exists ".vercel"; then R_DEPLOY="Vercel"
  elif _file_exists "fly.toml"; then R_DEPLOY="Fly.io"
  elif _file_exists "railway.json" || _file_exists "railway.toml"; then R_DEPLOY="Railway"
  elif _file_exists "netlify.toml"; then R_DEPLOY="Netlify"
  elif _file_exists "app.yaml" || _file_exists "app.yml"; then R_DEPLOY="GCP"
  elif _file_exists "Procfile"; then R_DEPLOY="Heroku"
  fi
  [ -z "$R_DEPLOY" ] && R_DEPLOY="Unknown"
}

# ---------------------------------------------------------------------------
# Dimension 5: Database
# ---------------------------------------------------------------------------
scan_database() {
  if _dir_exists "prisma"; then
    R_DB_TYPE="Prisma"
    if _file_exists "prisma/schema.prisma"; then
      R_DB_TABLES=$(_grep_c '^model ' "$PROJECT_DIR/prisma/schema.prisma")
    fi
    R_MIGRATION_COUNT=$(find "$PROJECT_DIR/prisma/migrations" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
  elif _file_exists "drizzle.config.ts" || _file_exists "drizzle.config.js"; then
    R_DB_TYPE="Drizzle"
    R_MIGRATION_COUNT=$(find "$PROJECT_DIR/drizzle" -name "*.sql" 2>/dev/null | wc -l | tr -d ' ')
  elif _dir_exists "alembic"; then
    R_DB_TYPE="Alembic (SQLAlchemy)"
    R_MIGRATION_COUNT=$(find "$PROJECT_DIR/alembic/versions" -name "*.py" 2>/dev/null | wc -l | tr -d ' ')
  fi
  [ -z "$R_DB_TYPE" ] && R_DB_TYPE="None"
}

# ---------------------------------------------------------------------------
# Dimension 6: Testing
# ---------------------------------------------------------------------------
scan_testing() {
  local t1 t2 t3 t4
  t1=$(_count_files "*.test.*")
  t2=$(_count_files "*.spec.*")
  t3=$(_count_files "test_*")
  t4=$(_count_files "*_test.go")
  R_TEST_COUNT=$((t1 + t2 + t3 + t4))

  if _file_exists "vitest.config.ts" || _file_exists "vitest.config.js"; then R_TEST_RUNNER="Vitest"
  elif _file_exists "jest.config.js" || _file_exists "jest.config.ts"; then R_TEST_RUNNER="Jest"
  elif _file_exists "pytest.ini"; then R_TEST_RUNNER="pytest"
  elif _file_exists "pyproject.toml" && grep -q 'pytest' "$PROJECT_DIR/pyproject.toml" 2>/dev/null; then R_TEST_RUNNER="pytest"
  elif _file_exists ".mocharc.yml" || _file_exists ".mocharc.json"; then R_TEST_RUNNER="Mocha"
  fi
  [ -z "$R_TEST_RUNNER" ] && R_TEST_RUNNER="None"

  if _file_exists "package.json" && grep -q 'coverage' "$PROJECT_DIR/package.json" 2>/dev/null; then
    R_HAS_COVERAGE="true"
  fi
}

# ---------------------------------------------------------------------------
# Dimension 7: Security — NEVER reads .env file contents
# ---------------------------------------------------------------------------
scan_security() {
  R_SECRET_HITS=0
  local hits
  hits=$(grep -rn \
    'sk_live_\|sk_test_\|AKIA[A-Z0-9]\|password[[:space:]]*=[[:space:]]*["'"'"'][^"'"'"']\|SECRET_KEY[[:space:]]*=[[:space:]]*["'"'"'][A-Za-z0-9]' \
    "$PROJECT_DIR" \
    --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
    --include="*.py" --include="*.rs" --include="*.go" --include="*.yaml" --include="*.yml" \
    --include="*.json" --include="*.toml" \
    2>/dev/null | grep -v node_modules | grep -v '\.git/' | grep -v 'package-lock' | grep -v '\.env\.example' || true)
  if [ -n "$hits" ]; then
    R_SECRET_HITS=$(echo "$hits" | wc -l | tr -d ' ')
  fi

  R_ENV_UNIGNORED="false"
  if _file_exists ".env"; then
    if _file_exists ".gitignore"; then
      if ! grep -q '\.env' "$PROJECT_DIR/.gitignore" 2>/dev/null; then
        R_ENV_UNIGNORED="true"
      fi
    else
      R_ENV_UNIGNORED="true"
    fi
  fi

  R_SECURITY_ISSUES=$R_SECRET_HITS
  [ "$R_ENV_UNIGNORED" = "true" ] && R_SECURITY_ISSUES=$((R_SECURITY_ISSUES + 1))
}

# ---------------------------------------------------------------------------
# Dimension 8: Code Quality
# ---------------------------------------------------------------------------
scan_code_quality() {
  if _file_exists ".eslintrc.js" || _file_exists ".eslintrc.json" || _file_exists ".eslintrc.yml" \
    || _file_exists "eslint.config.js" || _file_exists "eslint.config.mjs" || _file_exists "eslint.config.ts"; then
    R_HAS_ESLINT="true"
  elif _file_exists "package.json" && grep -q '"eslint"' "$PROJECT_DIR/package.json" 2>/dev/null; then
    R_HAS_ESLINT="true"
  fi
  if _file_exists ".prettierrc" || _file_exists ".prettierrc.json" || _file_exists ".prettierrc.js" \
    || _file_exists "prettier.config.js" || _file_exists "prettier.config.mjs"; then
    R_HAS_PRETTIER="true"
  elif _file_exists "package.json" && grep -q '"prettier"' "$PROJECT_DIR/package.json" 2>/dev/null; then
    R_HAS_PRETTIER="true"
  fi
  if _dir_exists ".husky" || (_file_exists "package.json" && grep -q '"lint-staged"\|"husky"' "$PROJECT_DIR/package.json" 2>/dev/null); then
    R_HAS_HUSKY="true"
  fi
  if _file_exists "tsconfig.json" && grep -q '"strict"[[:space:]]*:[[:space:]]*true' "$PROJECT_DIR/tsconfig.json" 2>/dev/null; then
    R_TS_STRICT="true"
  fi

  local src_includes='--include=*.ts --include=*.tsx --include=*.js --include=*.jsx --include=*.py --include=*.rs --include=*.go'
  R_TODO_COUNT=$(_grep_count -rn 'TODO' "$PROJECT_DIR" \
    --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
    --include="*.py" --include="*.rs" --include="*.go")
  R_FIXME_COUNT=$(_grep_count -rn 'FIXME' "$PROJECT_DIR" \
    --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
    --include="*.py" --include="*.rs" --include="*.go")
  R_HACK_COUNT=$(_grep_count -rn 'HACK' "$PROJECT_DIR" \
    --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
    --include="*.py" --include="*.rs" --include="*.go")
}

# ---------------------------------------------------------------------------
# Dimension 9: Performance
# ---------------------------------------------------------------------------
scan_performance() {
  R_NODE_MODULES_MB=$(_dir_size_mb "node_modules")
  R_DIST_MB=$(_dir_size_mb ".next")
  [ "$R_DIST_MB" = "0" ] && R_DIST_MB=$(_dir_size_mb "dist")
  [ "$R_DIST_MB" = "0" ] && R_DIST_MB=$(_dir_size_mb "build")
}

# ---------------------------------------------------------------------------
# Dimension 10: Documentation
# ---------------------------------------------------------------------------
scan_documentation() {
  if _file_exists "README.md"; then
    R_README_LINES=$(wc -l < "$PROJECT_DIR/README.md" 2>/dev/null | tr -d ' ')
  fi
  _dir_exists "docs" && R_HAS_DOCS="true"
  if _file_exists "openapi.yaml" || _file_exists "openapi.json" || _file_exists "swagger.json" || _file_exists "swagger.yaml"; then
    R_HAS_DOCS="true"
  fi
  R_JSDOC_COUNT=$(_grep_count -rn '/\*\*' "$PROJECT_DIR" \
    --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx")
}

# ---------------------------------------------------------------------------
# Dimension 11: Agent Ecosystem
# ---------------------------------------------------------------------------
scan_agent_ecosystem() {
  _file_exists "CLAUDE.md" && R_HAS_CLAUDE_MD="true"
  _file_exists ".cursorrules" && R_HAS_CURSORRULES="true"
  (_file_exists ".mcp.json" || _file_exists "mcp.json") && R_HAS_MCP="true"
  true  # ensure function returns 0
}

# ---------------------------------------------------------------------------
# Dimension 12: Dependencies
# ---------------------------------------------------------------------------
scan_dependencies() {
  if _file_exists "package-lock.json" || _file_exists "pnpm-lock.yaml" || _file_exists "yarn.lock" || _file_exists "bun.lockb"; then
    R_HAS_LOCKFILE="true"
  fi
  if _has_cmd npm && _file_exists "package.json"; then
    R_AUDIT_AVAILABLE="true"
    local audit_out
    audit_out=$(cd "$PROJECT_DIR" && npm audit --json 2>/dev/null || true)
    if [ -n "$audit_out" ]; then
      R_AUDIT_VULNS=$(echo "$audit_out" | sed -n 's/.*"total"[[:space:]]*:[[:space:]]*\([0-9]*\).*/\1/p' | head -1)
      [ -z "$R_AUDIT_VULNS" ] && R_AUDIT_VULNS=0
    fi
  fi
  _file_exists ".env.example" && R_HAS_ENV_EXAMPLE="true"
  _file_exists ".env.local.example" && R_HAS_ENV_EXAMPLE="true"
  true
}

# ---------------------------------------------------------------------------
# Error handling detection
# ---------------------------------------------------------------------------
scan_error_handling() {
  R_ERROR_HANDLING=$(_grep_count -rn 'try[[:space:]]*{' "$PROJECT_DIR" \
    --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx")
  local py_err
  py_err=$(_grep_count -rn 'except\|raise' "$PROJECT_DIR" --include="*.py")
  R_ERROR_HANDLING=$((R_ERROR_HANDLING + py_err))
}

# ---------------------------------------------------------------------------
# Health Score Calculation
# ---------------------------------------------------------------------------
calculate_score() {
  H_SCORE=0
  [ "$R_TEST_COUNT" -gt 0 ] && H_TEST_INFRA=15
  if [ "$R_SRC_FILE_COUNT" -gt 0 ] && [ "$R_TEST_COUNT" -gt 0 ]; then
    local ratio=$((R_TEST_COUNT * 100 / R_SRC_FILE_COUNT))
    [ "$ratio" -ge 10 ] && H_TEST_COVERAGE=5
  fi
  [ "$R_HAS_CI" = "true" ] && H_CICD=10
  [ "$R_SECRET_HITS" -eq 0 ] && H_NO_SECRETS=10
  [ "$R_TS_STRICT" = "true" ] && H_TS_STRICT=5
  [ "$R_HAS_ESLINT" = "true" ] && H_LINT=5
  [ "$R_HAS_PRETTIER" = "true" ] && H_FORMAT=3
  [ "$R_HAS_HUSKY" = "true" ] && H_PRECOMMIT=2
  [ "$R_README_LINES" -gt 50 ] && H_README=5
  [ "$R_HAS_DOCS" = "true" ] && H_API_DOCS=5
  [ "$R_JSDOC_COUNT" -gt 20 ] && H_JSDOC=3
  if _is_git && [ "$R_COMMIT_COUNT" -gt 10 ]; then
    H_GIT_HEALTH=5
  fi
  local total_debt=$((R_TODO_COUNT + R_FIXME_COUNT))
  [ "$total_debt" -lt 20 ] && H_NO_TODO=5
  [ "$R_DELETED_FILES" -lt 50 ] && [ "$R_HACK_COUNT" -lt 10 ] && H_NO_DEAD=5
  [ "$R_ERROR_HANDLING" -gt 5 ] && H_ERROR_HANDLING=5
  [ "$R_HAS_ENV_EXAMPLE" = "true" ] && H_ENV_DOC=3
  [ "$R_HAS_LOCKFILE" = "true" ] && [ "$R_AUDIT_VULNS" -eq 0 ] && H_DEPS=4
  if [ "$R_DIST_MB" -lt 200 ]; then H_BUNDLE=5; fi

  H_SCORE=$((H_TEST_INFRA + H_TEST_COVERAGE + H_CICD + H_NO_SECRETS + H_TS_STRICT + H_LINT + H_FORMAT + H_PRECOMMIT + H_README + H_API_DOCS + H_JSDOC + H_GIT_HEALTH + H_NO_TODO + H_NO_DEAD + H_ERROR_HANDLING + H_ENV_DOC + H_DEPS + H_BUNDLE))

  if [ "$H_SCORE" -ge 90 ]; then H_RATING="Excellent"
  elif [ "$H_SCORE" -ge 75 ]; then H_RATING="Good"
  elif [ "$H_SCORE" -ge 60 ]; then H_RATING="Needs Improvement"
  elif [ "$H_SCORE" -ge 40 ]; then H_RATING="At Risk"
  else H_RATING="Critical"; fi
}

# ---------------------------------------------------------------------------
# Priority Generation
# ---------------------------------------------------------------------------
generate_priorities() {
  H_PRIORITIES=""
  [ "$H_NO_SECRETS" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Fix exposed secrets/credentials
"
  [ "$H_TEST_INFRA" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Add test infrastructure
"
  [ "$H_CICD" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Set up CI/CD pipeline
"
  [ "$H_LINT" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Configure linting (ESLint or equivalent)
"
  [ "$H_TS_STRICT" -eq 0 ] && [ "$R_LANGUAGE" = "TypeScript" ] && H_PRIORITIES="${H_PRIORITIES}Enable TypeScript strict mode
"
  [ "$H_README" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Improve README documentation (aim for 50+ lines)
"
  [ "$H_ENV_DOC" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Add .env.example for environment documentation
"
  [ "$H_FORMAT" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Add code formatter (Prettier or equivalent)
"
  [ "$H_PRECOMMIT" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Set up pre-commit hooks (Husky)
"
  [ "$H_ERROR_HANDLING" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Improve error handling patterns
"
  [ "$H_NO_TODO" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Reduce TODO/FIXME count (currently $((R_TODO_COUNT + R_FIXME_COUNT)))
"
  [ "$H_DEPS" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Fix dependency vulnerabilities or add lockfile
"
  [ "$H_API_DOCS" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Add API/project documentation (/docs directory)
"
  [ "$H_JSDOC" -eq 0 ] && H_PRIORITIES="${H_PRIORITIES}Add JSDoc comments to key functions
"
  [ "$H_TEST_COVERAGE" -eq 0 ] && [ "$H_TEST_INFRA" -gt 0 ] && H_PRIORITIES="${H_PRIORITIES}Increase test coverage (aim for >10% of source files)
"
}

_priority() {
  echo "$H_PRIORITIES" | sed -n "${1}p"
}

# ---------------------------------------------------------------------------
# Output: Pretty (default)
# ---------------------------------------------------------------------------
output_pretty() {
  local w=62
  local test_status="None"
  if [ "$R_TEST_COUNT" -gt 0 ]; then
    test_status="$R_TEST_RUNNER configured"
    [ "$R_HAS_COVERAGE" = "true" ] && test_status="$test_status + coverage"
  fi

  local p1 p2 p3
  p1=$(_priority 1); [ -z "$p1" ] && p1="No critical issues found"
  p2=$(_priority 2); [ -z "$p2" ] && p2="Codebase is in good shape"
  p3=$(_priority 3); [ -z "$p3" ] && p3="Keep up the good work"

  local stack="${R_FRAMEWORK}"
  [ "$R_LANGUAGE" != "Unknown" ] && stack="${stack} · ${R_LANGUAGE}"
  [ "$R_STYLING" != "None" ] && [ "$R_STYLING" != "CSS" ] && stack="${stack} · ${R_STYLING}"
  [ "$R_ORM" != "None" ] && stack="${stack} · ${R_ORM}"

  local db_line="$R_DB_TYPE"
  [ "$R_DB_TYPE" != "None" ] && db_line="$R_DB_TYPE ($R_DB_TABLES tables)"

  local bw=$((w - 3))
  echo ""
  printf "  ╔"; printf '%0.s═' $(seq 1 $w); printf "╗\n"
  printf "  ║  %-${bw}s║\n" "SCALPEL — Codebase Vitals"
  printf "  ╠"; printf '%0.s═' $(seq 1 $w); printf "╣\n"
  printf "  ║  %-${bw}s║\n" ""
  printf "  ║  %-${bw}s║\n" "Project    : $R_NAME"
  printf "  ║  %-${bw}s║\n" "Stack      : $stack"
  printf "  ║  %-${bw}s║\n" "Database   : $db_line"
  printf "  ║  %-${bw}s║\n" "Auth       : $R_AUTH"
  printf "  ║  %-${bw}s║\n" "Deploy     : $R_DEPLOY (CI: $R_CI_TOOL)"
  printf "  ║  %-${bw}s║\n" "Tests      : $R_TEST_COUNT files ($test_status)"
  printf "  ║  %-${bw}s║\n" "Tech Debt  : $R_TODO_COUNT TODOs · $R_FIXME_COUNT FIXMEs"
  printf "  ║  %-${bw}s║\n" "Git Health : $R_COMMIT_COUNT commits · $R_BRANCH_COUNT branches"
  printf "  ║  %-${bw}s║\n" "Security   : $R_SECURITY_ISSUES issues"
  printf "  ║  %-${bw}s║\n" ""
  printf "  ║  %-${bw}s║\n" "HEALTH SCORE: ${H_SCORE}/100 — ${H_RATING}"
  printf "  ║  %-${bw}s║\n" ""
  printf "  ║  %-${bw}s║\n" "Top 3 Priorities:"
  printf "  ║  %-${bw}s║\n" "1. $p1"
  printf "  ║  %-${bw}s║\n" "2. $p2"
  printf "  ║  %-${bw}s║\n" "3. $p3"
  printf "  ║  %-${bw}s║\n" ""
  printf "  ╚"; printf '%0.s═' $(seq 1 $w); printf "╝\n"
  echo ""
}

# ---------------------------------------------------------------------------
# Output: JSON
# ---------------------------------------------------------------------------
_json_bool() { if [ "$1" = "true" ]; then printf 'true'; else printf 'false'; fi; }

output_json() {
  local ts
  ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%SZ")
  local p1 p2 p3
  p1=$(_priority 1); p2=$(_priority 2); p3=$(_priority 3)
  [ -z "$p1" ] && p1="No critical issues"
  [ -z "$p2" ] && p2="Codebase healthy"
  [ -z "$p3" ] && p3="Maintain standards"

  cat <<ENDJSON
{
  "version": "2.0",
  "timestamp": "$ts",
  "project": {
    "name": "$R_NAME",
    "path": "$PROJECT_DIR",
    "framework": "$R_FRAMEWORK",
    "language": "$R_LANGUAGE",
    "styling": "$R_STYLING",
    "orm": "$R_ORM"
  },
  "dimensions": {
    "project_dna": {
      "name": "$R_NAME",
      "framework": "$R_FRAMEWORK",
      "language": "$R_LANGUAGE",
      "dep_count": $R_DEP_COUNT,
      "is_monorepo": $(_json_bool "$R_IS_MONOREPO")
    },
    "architecture": {
      "source_files": $R_SRC_FILE_COUNT,
      "use_client_count": $R_USE_CLIENT,
      "router_type": "${R_ROUTER_TYPE:-N/A}"
    },
    "git_forensics": {
      "commit_count": $R_COMMIT_COUNT,
      "branch_count": $R_BRANCH_COUNT,
      "contributor_count": $R_CONTRIBUTOR_COUNT,
      "stash_count": $R_STASH_COUNT,
      "deleted_files": $R_DELETED_FILES
    },
    "infrastructure": {
      "has_docker": $(_json_bool "$R_HAS_DOCKER"),
      "has_ci": $(_json_bool "$R_HAS_CI"),
      "ci_tool": "$R_CI_TOOL",
      "deploy_platform": "$R_DEPLOY"
    },
    "database": {
      "type": "$R_DB_TYPE",
      "table_count": $R_DB_TABLES,
      "migration_count": $R_MIGRATION_COUNT
    },
    "testing": {
      "test_file_count": $R_TEST_COUNT,
      "runner": "$R_TEST_RUNNER",
      "has_coverage": $(_json_bool "$R_HAS_COVERAGE")
    },
    "security": {
      "secret_hits": $R_SECRET_HITS,
      "env_unignored": $(_json_bool "$R_ENV_UNIGNORED"),
      "total_issues": $R_SECURITY_ISSUES
    },
    "code_quality": {
      "has_eslint": $(_json_bool "$R_HAS_ESLINT"),
      "has_prettier": $(_json_bool "$R_HAS_PRETTIER"),
      "has_husky": $(_json_bool "$R_HAS_HUSKY"),
      "ts_strict": $(_json_bool "$R_TS_STRICT"),
      "todo_count": $R_TODO_COUNT,
      "fixme_count": $R_FIXME_COUNT,
      "hack_count": $R_HACK_COUNT
    },
    "performance": {
      "node_modules_mb": $R_NODE_MODULES_MB,
      "dist_mb": $R_DIST_MB,
      "use_client_ratio": "$R_USE_CLIENT / $R_SRC_FILE_COUNT"
    },
    "documentation": {
      "readme_lines": $R_README_LINES,
      "has_docs_dir": $(_json_bool "$R_HAS_DOCS"),
      "jsdoc_count": $R_JSDOC_COUNT
    },
    "agent_ecosystem": {
      "has_claude_md": $(_json_bool "$R_HAS_CLAUDE_MD"),
      "has_cursorrules": $(_json_bool "$R_HAS_CURSORRULES"),
      "has_mcp_config": $(_json_bool "$R_HAS_MCP")
    },
    "dependencies": {
      "has_lockfile": $(_json_bool "$R_HAS_LOCKFILE"),
      "audit_available": $(_json_bool "$R_AUDIT_AVAILABLE"),
      "audit_vulnerabilities": $R_AUDIT_VULNS,
      "has_env_example": $(_json_bool "$R_HAS_ENV_EXAMPLE")
    }
  },
  "health": {
    "score": $H_SCORE,
    "rating": "$H_RATING",
    "breakdown": {
      "test_infrastructure": $H_TEST_INFRA,
      "test_coverage": $H_TEST_COVERAGE,
      "cicd_pipeline": $H_CICD,
      "no_exposed_secrets": $H_NO_SECRETS,
      "typescript_strict": $H_TS_STRICT,
      "linting": $H_LINT,
      "formatting": $H_FORMAT,
      "precommit_hooks": $H_PRECOMMIT,
      "readme": $H_README,
      "api_docs": $H_API_DOCS,
      "jsdoc": $H_JSDOC,
      "git_health": $H_GIT_HEALTH,
      "no_todo_overload": $H_NO_TODO,
      "no_dead_code": $H_NO_DEAD,
      "error_handling": $H_ERROR_HANDLING,
      "env_documented": $H_ENV_DOC,
      "deps_healthy": $H_DEPS,
      "bundle_optimized": $H_BUNDLE
    },
    "priorities": [
      "$p1",
      "$p2",
      "$p3"
    ]
  }
}
ENDJSON
}

# ---------------------------------------------------------------------------
# Output: CI (GitHub Actions annotations)
# ---------------------------------------------------------------------------
output_ci() {
  echo "::notice file=scanner.sh::Health Score: ${H_SCORE}/100 - ${H_RATING}"
  [ "$H_NO_SECRETS" -eq 0 ] && echo "::error::${R_SECRET_HITS} exposed secret pattern(s) detected"
  [ "$R_ENV_UNIGNORED" = "true" ] && echo "::error::.env file exists but is not in .gitignore"
  [ "$H_TEST_INFRA" -eq 0 ] && echo "::warning::No test files found"
  [ "$H_CICD" -eq 0 ] && echo "::warning::No CI/CD pipeline configured"
  [ "$H_LINT" -eq 0 ] && echo "::warning::No linter configured"
  [ "$H_README" -eq 0 ] && echo "::warning::README.md is missing or too short (<50 lines)"
  [ "$H_NO_TODO" -eq 0 ] && echo "::warning::High tech debt: $((R_TODO_COUNT + R_FIXME_COUNT)) TODO/FIXME comments"
  [ "$R_AUDIT_VULNS" -gt 0 ] && echo "::warning::${R_AUDIT_VULNS} dependency vulnerabilities found"
  local p1 p2 p3
  p1=$(_priority 1); p2=$(_priority 2); p3=$(_priority 3)
  [ -n "$p1" ] && echo "::notice::Priority 1: $p1"
  [ -n "$p2" ] && echo "::notice::Priority 2: $p2"
  [ -n "$p3" ] && echo "::notice::Priority 3: $p3"
  true
}

# ---------------------------------------------------------------------------
# Output: Markdown
# ---------------------------------------------------------------------------
output_markdown() {
  local test_status="None"
  [ "$R_TEST_COUNT" -gt 0 ] && test_status="$R_TEST_RUNNER"
  local p1 p2 p3
  p1=$(_priority 1); p2=$(_priority 2); p3=$(_priority 3)
  [ -z "$p1" ] && p1="No critical issues"
  [ -z "$p2" ] && p2="Codebase healthy"
  [ -z "$p3" ] && p3="Maintain standards"

  cat <<ENDMD
# Scalpel Codebase Vitals

| Metric | Value |
|--------|-------|
| **Project** | $R_NAME |
| **Framework** | $R_FRAMEWORK |
| **Language** | $R_LANGUAGE |
| **Database** | $R_DB_TYPE ($R_DB_TABLES tables) |
| **Deploy** | $R_DEPLOY (CI: $R_CI_TOOL) |
| **Tests** | $R_TEST_COUNT files ($test_status) |
| **Tech Debt** | $R_TODO_COUNT TODOs, $R_FIXME_COUNT FIXMEs |
| **Security** | $R_SECURITY_ISSUES issue(s) |

## Health Score: ${H_SCORE}/100 — ${H_RATING}

### Score Breakdown

| Category | Points | Max |
|----------|--------|-----|
| Test Infrastructure | $H_TEST_INFRA | 15 |
| Test Coverage | $H_TEST_COVERAGE | 5 |
| CI/CD Pipeline | $H_CICD | 10 |
| No Exposed Secrets | $H_NO_SECRETS | 10 |
| TypeScript Strict | $H_TS_STRICT | 5 |
| Linting | $H_LINT | 5 |
| Formatting | $H_FORMAT | 3 |
| Pre-commit Hooks | $H_PRECOMMIT | 2 |
| README | $H_README | 5 |
| API Documentation | $H_API_DOCS | 5 |
| JSDoc Coverage | $H_JSDOC | 3 |
| Git Health | $H_GIT_HEALTH | 5 |
| No TODO Overload | $H_NO_TODO | 5 |
| No Dead Code | $H_NO_DEAD | 5 |
| Error Handling | $H_ERROR_HANDLING | 5 |
| Env Documented | $H_ENV_DOC | 3 |
| Dependencies | $H_DEPS | 4 |
| Bundle Optimized | $H_BUNDLE | 5 |

### Top Priorities

1. $p1
2. $p2
3. $p3

---
*Generated by [Scalpel](https://github.com/scalpel) v${SCANNER_VERSION}*
ENDMD
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  scan_project_dna
  scan_architecture
  scan_git
  scan_infrastructure
  scan_database
  scan_testing
  scan_security
  scan_code_quality
  scan_performance
  scan_documentation
  scan_agent_ecosystem
  scan_dependencies
  scan_error_handling
  calculate_score
  generate_priorities

  case "$OUTPUT_MODE" in
    json)     output_json ;;
    ci)       output_ci ;;
    markdown) output_markdown ;;
    score)    echo "$H_SCORE" ;;
    pretty)   output_pretty ;;
  esac
}

main
