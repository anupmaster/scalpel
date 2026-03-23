# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0.0] - 2026-03-24

### Added

- **Standalone Scanner** (`src/scanner.sh`) — 827-line pure bash script that runs the full 12-dimension codebase diagnostic independently of any AI agent. Five output modes: pretty terminal, JSON, GitHub Actions CI annotations, Markdown, and score-only.
- **Multi-Agent Adapters** — dedicated adapter files for all 7 supported agents: Claude Code (native), Codex CLI (`adapters/codex.md`), Gemini CLI (`adapters/gemini.md`), OpenCode (`adapters/opencode.md`), Cursor (`adapters/cursor.md`), Windsurf (`adapters/windsurf.md`), and Aider (`adapters/aider.md`).
- **Extensible Configuration** (`scalpel.config.json`) — project-level config with JSON Schema validation (`schemas/config.schema.json`). Supports custom scan dimensions, custom team roles, custom scoring rules, monitoring intervals, and session memory settings.
- **Session Memory** — persistent JSONL memory file (`.scalpel/memory.jsonl`) that records session summaries, scores, decisions, and context across Scalpel runs.
- **Continuous Monitoring** — `/loop` mode that re-scans the project at configurable intervals and alerts when the health score drops below the threshold.
- **GitHub Action** (`action.yml`) — CI integration that runs the scanner on pull requests, posts a Markdown health report as a PR comment, and fails the check if the score falls below a configurable threshold.
- **Test Suite** (`tests/scanner/`) — test runner (`run_tests.sh`), fixture generator (`setup_fixtures.sh`), and project fixtures (Next.js, Python/FastAPI, empty repo) for validating scanner behavior.
- **Configuration Documentation** (`docs/CONFIGURATION.md`) — comprehensive guide to `scalpel.config.json` with field reference, custom dimensions, custom roles, custom scoring rules, monitoring config, and stack-specific examples.

### Changed

- **Works With table** — all 7 agents now listed as Full Support with adapter file references.
- **Project Structure** — updated to reflect v2 file tree including `adapters/`, `schemas/`, `tests/`, `action.yml`, and `CHANGELOG.md`.
- **Agent orchestration prompt** (`src/scalpel.md`) — updated to consume scanner output instead of performing inline scanning, reducing token usage significantly.

## [1.0.0] - 2026-03-23

### Added

- Initial release of Scalpel.
- **12-Dimension Diagnostic** — automated codebase scanning across project DNA, architecture, git forensics, infrastructure, database, testing, auth & security, integrations, agent ecosystem, code quality, performance, and documentation.
- **Codebase Vitals Report** — shareable health score (0-100) with top priorities.
- **Adaptive Surgical Teams** — dynamic team assembly based on project characteristics with file jurisdiction, forbidden zones, and worktree isolation.
- **Agent Scoring System** — real-time quality monitoring with deductions for jurisdiction violations, build breakage, regressions, and pattern violations. Auto-correction at score < 70, termination at score < 50.
- **Pendrive Architecture** — zero-trace plug-in/plug-out design. Never modifies existing CLAUDE.md, package.json, or git history.
- **Claude Code integration** — native `.claude/agents/` support.
- **Partial support** for Codex CLI, Gemini CLI, OpenCode, Cursor, Windsurf, and Aider.
- `install.sh` and `uninstall.sh` scripts for portable installation.
- MIT License.
