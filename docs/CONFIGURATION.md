# Scalpel Configuration Guide

Scalpel v2 uses a project-level configuration file (`scalpel.config.json`) to customize scanning, team assembly, scoring, monitoring, and memory. The config is optional — Scalpel works with sensible defaults out of the box.

## Quick Start

Drop a `scalpel.config.json` in your project root:

```json
{
  "$schema": "https://raw.githubusercontent.com/anupmaster/scalpel/main/schemas/config.schema.json",
  "version": "2.0"
}
```

The `$schema` field enables autocompletion and validation in VS Code and other editors that support JSON Schema.

## Field Reference

### `version` (required)

Configuration format version. Must be `"2.0"`.

```json
{ "version": "2.0" }
```

### `scan`

Controls which dimensions are scanned, paths to ignore, and secret detection patterns.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `scan.dimensions.include` | `string[]` | `["all"]` | Dimensions to scan. Use `["all"]` or list specific ones. |
| `scan.dimensions.exclude` | `string[]` | `[]` | Dimensions to skip, even when using `["all"]`. |
| `scan.dimensions.custom` | `object[]` | `[]` | User-defined dimensions (see below). |
| `scan.ignore_paths` | `string[]` | `["vendor/", "node_modules/", ...]` | Glob patterns the scanner skips. |
| `scan.secret_patterns` | `string[]` | `[]` | Additional regex patterns for secret detection. |

**Built-in dimensions:** `project_dna`, `architecture`, `git_forensics`, `infrastructure`, `database`, `testing`, `security`, `code_quality`, `performance`, `documentation`, `agent_ecosystem`.

Example — scan only testing and security:

```json
{
  "scan": {
    "dimensions": {
      "include": ["testing", "security"]
    }
  }
}
```

Example — scan everything except performance:

```json
{
  "scan": {
    "dimensions": {
      "include": ["all"],
      "exclude": ["performance"]
    }
  }
}
```

### `team`

Controls agent team assembly during Phase 3.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `team.max_agents` | `integer` | `4` | Maximum parallel agents (3-6). |
| `team.default_model` | `string` | `"sonnet"` | Model for implementation agents. Options: `opus`, `sonnet`, `haiku`. |
| `team.architect_model` | `string` | `"opus"` | Model for strategic reasoning (Phase 2-3). Options: `opus`, `sonnet`, `haiku`. |
| `team.custom_roles` | `object[]` | `[]` | Additional specialist roles (see below). |

### `scoring`

Extend the health score algorithm.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `scoring.custom_rules` | `object[]` | `[]` | User-defined scoring rules (see below). |
| `scoring.thresholds.excellent` | `integer` | `90` | Minimum score for "Excellent" rating. |
| `scoring.thresholds.good` | `integer` | `75` | Minimum score for "Good" rating. |
| `scoring.thresholds.needs_improvement` | `integer` | `60` | Minimum score for "Needs Improvement" rating. |
| `scoring.thresholds.at_risk` | `integer` | `40` | Minimum score for "At Risk" rating. Below this is "Critical". |

### `monitoring`

Settings for `/loop` continuous monitoring mode.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `monitoring.interval_minutes` | `integer` | `30` | Re-scan interval during `/loop` (5-1440). |
| `monitoring.alert_threshold` | `integer` | `5` | Score drop (in points) that triggers an alert. |
| `monitoring.auto_start` | `boolean` | `false` | Automatically enter monitoring after Phase 5. |

### `memory`

Controls persistent session memory.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `memory.enabled` | `boolean` | `true` | Write session summaries after each run. |
| `memory.path` | `string` | `".scalpel/memory.jsonl"` | Path to the JSONL memory file (relative to project root). |

---

## Custom Dimensions

Add your own scan checks that run alongside the built-in 12. Each custom dimension is a bash command — exit 0 means pass, non-zero means fail.

```json
{
  "scan": {
    "dimensions": {
      "include": ["all"],
      "custom": [
        {
          "name": "accessibility_audit",
          "description": "Check that all images have alt attributes",
          "command": "! grep -rn '<img ' --include='*.tsx' --include='*.jsx' src/ | grep -v 'alt=' | head -1 | grep -q '.'",
          "scoring": { "pass": 5, "fail": 0 }
        },
        {
          "name": "bundle_size_check",
          "description": "Verify production bundle stays under 200KB",
          "command": "test -d .next && find .next/static/chunks -name '*.js' -exec du -cb {} + | tail -1 | awk '{exit ($1 > 204800)}'",
          "scoring": { "pass": 5, "fail": 0 }
        },
        {
          "name": "no_hardcoded_urls",
          "description": "Ensure no hardcoded localhost or staging URLs in source",
          "command": "! grep -rn 'localhost:\\|staging\\.' --include='*.ts' --include='*.tsx' src/ | grep -v 'test\\|spec\\|mock' | grep -q '.'",
          "scoring": { "pass": 3, "fail": 0 }
        }
      ]
    }
  }
}
```

**Fields:**

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `name` | `string` | 3-50 chars, `snake_case` | Unique identifier. |
| `description` | `string` | 10-200 chars | Human-readable explanation. |
| `command` | `string` | 1-1000 chars | Bash command. Exit 0 = pass. |
| `scoring.pass` | `integer` | 0-10 | Points awarded on pass. |
| `scoring.fail` | `integer` | 0-10 | Points awarded on fail (typically 0). |

---

## Custom Roles

Define specialist agents that the Architect can assign when conditions match. Each role has a trigger condition (bash command), file jurisdiction, and a system prompt.

```json
{
  "team": {
    "custom_roles": [
      {
        "name": "i18n-specialist",
        "trigger": "test -d src/locales || grep -q 'next-intl\\|react-i18next' package.json",
        "jurisdiction": [
          "src/locales/**",
          "public/locales/**",
          "src/**/i18n*",
          "next-i18next.config.*"
        ],
        "prompt": "You are an internationalization specialist. Audit translation files for missing keys across locales, ensure all user-facing strings are extracted, validate locale fallback chains, and check date/number formatting uses the i18n library."
      },
      {
        "name": "graphql-specialist",
        "trigger": "grep -q 'graphql\\|@apollo' package.json 2>/dev/null || test -f schema.graphql",
        "jurisdiction": [
          "src/**/*.graphql",
          "src/**/resolvers/**",
          "src/**/schema/**",
          "codegen.ts"
        ],
        "prompt": "You are a GraphQL specialist. Audit schema design, resolver efficiency, N+1 query patterns, and type generation pipeline. Ensure all queries use proper fragments and error handling."
      }
    ]
  }
}
```

**Fields:**

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `name` | `string` | 3-40 chars, `kebab-case` | Display name for the role. |
| `trigger` | `string` | 1-500 chars | Bash condition. Exit 0 = include this role. |
| `jurisdiction` | `string[]` | Min 1 item | Glob patterns for files this role owns. |
| `prompt` | `string` | 20-5000 chars | System prompt defining expertise and rules. |

---

## Custom Scoring Rules

Add project-specific quality checks to the health score. Each rule runs a bash command — exit 0 means the rule passes (bonus applied), non-zero means it fails (deduction applied).

```json
{
  "scoring": {
    "custom_rules": [
      {
        "name": "no_console_log_in_components",
        "check": "! grep -rn 'console\\.log' --include='*.tsx' --include='*.jsx' src/components/ | grep -q '.'",
        "deduction": -3,
        "bonus": 0,
        "message": "console.log found in React components — use a proper logger."
      },
      {
        "name": "env_example_in_sync",
        "check": "test -f .env.example && diff <(grep -oE '^[A-Z_]+' .env.example | sort) <(grep -oE '^[A-Z_]+' .env.local | sort) > /dev/null 2>&1",
        "deduction": -2,
        "bonus": 3,
        "message": ".env.example and .env.local have mismatched variable names."
      },
      {
        "name": "no_skipped_tests",
        "check": "! grep -rn '\\.skip\\|xit\\|xdescribe\\|xtest' --include='*.test.*' --include='*.spec.*' src/ | grep -q '.'",
        "deduction": -2,
        "bonus": 0,
        "message": "Skipped tests found — remove .skip or re-enable them."
      }
    ]
  }
}
```

**Fields:**

| Field | Type | Default | Constraints | Description |
|-------|------|---------|-------------|-------------|
| `name` | `string` | — | 3-60 chars | Rule identifier. |
| `check` | `string` | — | 1-1000 chars | Bash command. Exit 0 = pass. |
| `deduction` | `integer` | `0` | -5 to 0 | Points deducted on failure. |
| `bonus` | `integer` | `0` | 0 to 10 | Points awarded on pass. |
| `message` | `string` | — | 5-200 chars | Message shown in the report when triggered. |

---

## Monitoring Config

Configure how Scalpel behaves during long sessions with `/loop` mode.

```json
{
  "monitoring": {
    "interval_minutes": 15,
    "alert_threshold": 3,
    "auto_start": true
  }
}
```

- **`interval_minutes: 15`** — re-scan every 15 minutes (range: 5-1440).
- **`alert_threshold: 3`** — alert if score drops by 3 or more points between scans.
- **`auto_start: true`** — automatically enter monitoring mode after Phase 5 completes instead of requiring a manual `/loop` command.

For short-lived sessions, leave `auto_start` as `false` and invoke monitoring manually when needed.

---

## Stack-Specific Examples

### Next.js + Prisma + Vercel

Key additions: Prisma migration check, `"use client"` directive limit, Stripe secret detection.

```json
{
  "version": "2.0",
  "scan": {
    "dimensions": {
      "include": ["all"],
      "exclude": ["performance"],
      "custom": [{
        "name": "prisma_migrations_clean",
        "description": "Ensure no pending Prisma migrations",
        "command": "npx prisma migrate status 2>&1 | grep -q 'Database schema is up to date'",
        "scoring": { "pass": 5, "fail": 0 }
      }]
    },
    "ignore_paths": ["node_modules/", ".next/", "dist/", "coverage/"],
    "secret_patterns": ["NEXT_PUBLIC_STRIPE_SECRET"]
  },
  "scoring": {
    "custom_rules": [{
      "name": "no_client_directive_abuse",
      "check": "test $(grep -rn '\"use client\"' --include='*.tsx' src/ | wc -l) -lt 20",
      "deduction": -3,
      "message": "Too many 'use client' directives — consider server components."
    }]
  }
}
```

### Python (FastAPI + SQLAlchemy + Alembic)

Key additions: Alembic head check, type hint enforcement, bare-except detection.

```json
{
  "version": "2.0",
  "scan": {
    "dimensions": {
      "include": ["all"],
      "custom": [{
        "name": "alembic_heads_clean",
        "description": "Ensure only one Alembic migration head exists",
        "command": "test $(alembic heads 2>/dev/null | wc -l) -le 1",
        "scoring": { "pass": 5, "fail": 0 }
      }]
    },
    "ignore_paths": ["__pycache__/", ".venv/", ".mypy_cache/", "htmlcov/"]
  },
  "scoring": {
    "custom_rules": [{
      "name": "no_bare_except",
      "check": "! grep -rn 'except:' --include='*.py' src/ | grep -v '# noqa' | grep -q '.'",
      "deduction": -3,
      "message": "Bare except clauses found — catch specific exceptions."
    }]
  }
}
```

### Rust CLI Application

Key additions: clippy enforcement, unwrap ban in library code, public docs check. Scans only relevant dimensions (no database, infrastructure, etc.).

```json
{
  "version": "2.0",
  "scan": {
    "dimensions": {
      "include": ["project_dna", "architecture", "git_forensics", "testing", "code_quality", "documentation"],
      "custom": [{
        "name": "clippy_clean",
        "description": "Ensure cargo clippy passes with no warnings",
        "command": "cargo clippy --all-targets 2>&1 | grep -q 'warning' && exit 1 || exit 0",
        "scoring": { "pass": 5, "fail": 0 }
      }]
    },
    "ignore_paths": ["target/", "vendor/"]
  },
  "scoring": {
    "custom_rules": [{
      "name": "docs_on_public_items",
      "check": "cargo doc --no-deps 2>&1 | grep -c 'missing documentation' | awk '{exit ($1 > 5)}'",
      "deduction": -2,
      "bonus": 3,
      "message": "Public items missing documentation — add /// doc comments."
    }]
  }
}
```

---

## Validation

The configuration is validated against [schemas/config.schema.json](../schemas/config.schema.json). To validate manually:

```bash
# Using npx with ajv-cli
npx ajv validate -s schemas/config.schema.json -d scalpel.config.json

# Or in VS Code — just add the $schema field and get inline validation
```

If no `scalpel.config.json` is found, Scalpel uses defaults: all dimensions, 4 agents, sonnet model, 30-minute monitoring interval, memory enabled.
