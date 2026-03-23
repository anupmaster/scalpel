<p align="center">
  <img src="https://img.shields.io/badge/🔪-SCALPEL-black?style=for-the-badge&labelColor=dc2626" alt="Scalpel">
</p>

<h1 align="center">Surgical AI for Your Codebase</h1>

<p align="center">
  <strong>12-dimension diagnostic. Adaptive surgical teams. Zero side effects.</strong>
</p>

<p align="center">
  <a href="https://github.com/anupmaster/scalpel/stargazers"><img src="https://img.shields.io/github/stars/anupmaster/scalpel?style=for-the-badge&color=f59e0b&labelColor=1c1917" alt="Stars"></a>
  <a href="https://github.com/anupmaster/scalpel/releases"><img src="https://img.shields.io/github/v/release/anupmaster/scalpel?style=for-the-badge&color=22c55e&labelColor=1c1917" alt="Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-3b82f6?style=for-the-badge&labelColor=1c1917" alt="MIT License"></a>
  <a href="#-works-with-every-ai-agent"><img src="https://img.shields.io/badge/Agents-7_Supported-a855f7?style=for-the-badge&labelColor=1c1917" alt="7 Agents"></a>
</p>

<p align="center">
  <sub>Created by <a href="https://github.com/anupmaster"><strong>Anup Karanjkar</strong></a> &middot; 12+ years building digital products</sub>
</p>

<br>

<div align="center">
  <table>
    <tr>
      <td align="center">
        <strong>The Problem</strong><br>
        AI agents write code <em>without understanding your project</em>.<br>
        They guess your stack, your patterns, your conventions.<br>
        <strong>Guessing at scale = bugs at scale.</strong>
      </td>
      <td align="center">
        <strong>The Solution</strong><br>
        Scalpel gives any AI agent <em>deep project intelligence</em><br>
        before it writes a single line of code.<br>
        <strong>Plug in. Diagnose. Operate. Unplug.</strong>
      </td>
    </tr>
  </table>
</div>

<br>

```bash
# 30 seconds to surgical precision
cd your-project
git clone https://github.com/anupmaster/scalpel.git .scalpel && .scalpel/install.sh

# Then in any AI agent:
> Hi Scalpel, start work
```

<br>

## 🔍 Instant Codebase Health Check — Zero AI Required

Run the standalone scanner. No subscription. No API keys. No tokens. **Pure bash.**

```bash
./scanner.sh                    # Pretty terminal output
./scanner.sh --json             # Machine-readable JSON
./scanner.sh --ci               # GitHub Actions annotations
./scanner.sh --markdown         # Markdown report for PRs
./scanner.sh --score-only       # Just the number: "83"
```

```
  ╔══════════════════════════════════════════════════════════════╗
  ║  SCALPEL — Codebase Vitals                                  ║
  ╠══════════════════════════════════════════════════════════════╣
  ║                                                              ║
  ║  Project    : acme-dashboard                                 ║
  ║  Stack      : Next.js 14 · TypeScript · Tailwind · Prisma   ║
  ║  Database   : PostgreSQL via Supabase (23 tables)            ║
  ║  Auth       : Auth.js v5                                     ║
  ║  Deploy     : Vercel (CI: GitHub Actions)                    ║
  ║  Tests      : 0 files CRITICAL (None)                        ║
  ║  Tech Debt  : 47 TODOs · 12 FIXMEs · 3 HACKs               ║
  ║  Git Health : 1247 commits · 5 branches · 3 contributors    ║
  ║  Bundle     : 847MB node_modules                             ║
  ║  Security   : 2 issues found                                 ║
  ║                                                              ║
  ║  HEALTH SCORE: 64/100 — Needs Improvement                   ║
  ║  [###############---------]                                  ║
  ║                                                              ║
  ║  Top 3 Priorities:                                           ║
  ║  1. Add test infrastructure (0% coverage)                    ║
  ║  2. Fix 2 security vulnerabilities in dependencies           ║
  ║  3. Reduce bundle size (tree-shake unused imports)           ║
  ║                                                              ║
  ╚══════════════════════════════════════════════════════════════╝
```

> **This report alone is worth the install.** Screenshot it. Share it. Put it in your README.

<br>

## 🩺 What Happens When You Say "Hi Scalpel"

```
 PHASE 0 — PRE-FLIGHT
 Reads previous session memory. Loads your config.
 "Returning to acme-dashboard. Last session: health 48 → 74."

 PHASE 1 — DIAGNOSE  (2 min, fully autonomous)
 Scans 12 dimensions: stack, architecture, git forensics,
 database, auth, infra, tests, security, and more.
 Outputs the Codebase Vitals report.

 PHASE 2 — CONSULT
 Asks 5-7 surgical questions that only YOU can answer.
 Memory-aware: skips what was already addressed.

 PHASE 3 — ASSEMBLE
 Designs a custom surgical team for YOUR project.
 Not a template. Adaptive specialists with file jurisdiction.

 PHASE 4 — OPERATE
 Spawns parallel agents in isolated git worktrees.
 Monitors quality. Scores each agent. Terminates drift.

 PHASE 5 — CLOSE
 Delivery report. Session memory saved.
 "Monitor for regressions? Debrief a surgeon? Done?"
```

<br>

## 🔪 Adaptive Surgical Teams

Scalpel doesn't use templates. It reads your project and designs the right team:

```
 Your Project                          Your Surgical Team
 ─────────────────────                 ───────────────────────────────────────
 DB + API + Frontend                →  Data Layer · API · Frontend · Guardian
 Frontend-heavy SaaS                →  Components · State · Performance · Guardian
 Drowning in tech debt              →  Debt Liquidator · Tests · Deps · Guardian
 Early-stage prototype              →  Foundation · Test Infra · CI/CD · Guardian
 Bug investigation                  →  3 Hypothesis Investigators · Guardian
```

Each surgeon gets **file jurisdiction** (no merge conflicts), **worktree isolation** (parallel work), and a **quality score** starting at 100. Score drops below 50? Terminated and work redistributed.

<br>

## 🏗️ The 12-Dimension Diagnostic

| # | Dimension | What It Discovers |
|:-:|-----------|------------------|
| 1 | **Project DNA** | Framework, language, dependencies, versions, monorepo structure |
| 2 | **Architecture** | Entry points, routing, data flow, state management, styling |
| 3 | **Git Forensics** | Commit velocity, branching strategy, deleted files, abandoned work |
| 4 | **Infrastructure** | Docker, CI/CD, deployment target, reverse proxy, IaC |
| 5 | **Database** | ORM, schema, migrations history, seed data, table count |
| 6 | **Testing** | Runner, coverage, E2E scenarios, test health |
| 7 | **Auth & Security** | Provider, protected routes, RBAC, exposed secrets scan |
| 8 | **Integrations** | Payments, email, storage, analytics, monitoring |
| 9 | **Agent Ecosystem** | Existing CLAUDE.md, agents, commands, MCP servers, hooks |
| 10 | **Code Quality** | Linting, formatting, pre-commit hooks, strict mode, TODO count |
| 11 | **Performance** | Bundle size, image optimization, caching, rendering strategy |
| 12 | **Documentation** | README quality, API docs, JSDoc coverage, ADRs |

<br>

## 🔬 Works With Every AI Agent

| Agent | Status | How to Install |
|-------|:------:|----------------|
| **Claude Code** | ✅ | `./install.sh --claude` → `.claude/agents/scalpel.md` |
| **Codex CLI** | ✅ | `./install.sh --codex` → `AGENTS.md` |
| **Gemini CLI** | ✅ | `./install.sh --gemini` → `GEMINI.md` |
| **Cursor** | ✅ | `./install.sh --cursor` → `.cursorrules` |
| **Windsurf** | ✅ | `./install.sh --windsurf` → `.windsurfrules` |
| **Aider** | ✅ | `./install.sh --aider` → conventions file |
| **OpenCode** | ✅ | `./install.sh --opencode` → agent config |

```bash
./install.sh          # Auto-detects your agent
./install.sh --all    # Install for everything
```

<br>

## ⚡ Quick Start

**Option 1: Clone and plug in**
```bash
git clone https://github.com/anupmaster/scalpel.git ~/scalpel
cd your-project && ~/scalpel/install.sh
```

**Option 2: Global install (available everywhere)**
```bash
mkdir -p ~/.claude/agents
curl -fsSL https://raw.githubusercontent.com/anupmaster/scalpel/main/src/scalpel.md \
  -o ~/.claude/agents/scalpel.md
```

**Option 3: Just the scanner**
```bash
curl -fsSL https://raw.githubusercontent.com/anupmaster/scalpel/main/src/scanner.sh \
  -o scanner.sh && chmod +x scanner.sh
./scanner.sh /path/to/any/project
```

**Then:**
```bash
claude    # or codex, gemini, cursor, windsurf, aider, opencode
> Hi Scalpel, start work
```

<br>

## 🔄 GitHub Action — PR Health Gate

Block unhealthy code from merging. Automatically.

```yaml
# .github/workflows/scalpel.yml
name: Scalpel Health Check
on: [pull_request]
jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: anupmaster/scalpel@v2
        with:
          fail-below: 60    # Block merge if health drops below 60
          comment: true      # Post Vitals as PR comment
```

Every PR gets a before/after health score comparison posted as a comment. Set your threshold. Enforce it.

<br>

## 🧮 Agent Scoring System

Scalpel monitors every teammate in real-time:

| Violation | Points |
|-----------|:------:|
| **Removed or downgraded existing functionality** | **-25** |
| **Simplified output/UI below original quality** | **-25** |
| Introduced a regression (existing tests fail) | -20 |
| Broke the build | -15 |
| Modified file outside jurisdiction | -10 |
| Used `any` type or skipped error handling | -10 |
| Ignored established project patterns | -10 |
| Left `console.log` in production code | -5 |

**Score < 70** — Scalpel re-issues instructions with corrections.<br>
**Score < 50** — Agent terminated. Work redistributed.

> The harshest penalties are for quality downgrades, not build breaks. A broken build is obvious. A silent feature removal ships unnoticed and erodes trust.

<br>

## 🔌 The Pendrive Principle

Scalpel is designed like a **forensic USB toolkit**:

```
 Plug in   → install.sh (auto-detects your agent)
 Do work   → Diagnose, assemble team, operate
 Plug out  → uninstall.sh --purge
 Zero trace — your git history never shows Scalpel was there
```

**What Scalpel NEVER touches:** your CLAUDE.md, your agents, your package.json, your git history.<br>
**What Scalpel leaves behind:** improved code. That's it.

<br>

## 🆕 What's New in v2

| Feature | Impact |
|---------|--------|
| **Standalone Scanner** | 12-dimension diagnostic from terminal. Zero AI, zero tokens. |
| **60% Fewer Tokens** | Scanner + effort-level routing = massive cost reduction |
| **Session Memory** | `.scalpel/memory.jsonl` — Scalpel learns across sessions |
| **7 Agent Adapters** | Claude Code, Codex, Gemini, Cursor, Windsurf, Aider, OpenCode |
| **Continuous Monitoring** | `/loop` regression detection during long sessions |
| **Post-Surgery Q&A** | Ask any surgeon about their decisions after delivery |
| **GitHub Action** | Automated PR health checks with merge gating |
| **Extensible Config** | `scalpel.config.json` — custom dimensions, roles, scoring |
| **Anti-Regression System** | Agents can never silently remove or downgrade features. Mandatory before/after verification. |

<br>

## 📂 Project Structure

```
scalpel/
├── src/
│   ├── scalpel.md                # Agent brain — orchestration prompt
│   ├── scanner.sh                # Standalone scanner (827 lines, pure bash)
│   └── adapters/                 # 6 agent-specific adapters
│       ├── codex.md
│       ├── gemini.md
│       ├── cursor.cursorrules
│       ├── windsurf.md
│       ├── aider.md
│       └── opencode.md
├── schemas/
│   └── config.schema.json        # Config validation schema
├── tests/
│   └── scanner/                  # 36-assertion test suite
├── docs/
│   ├── SPECIFICATION.md          # Technical specification
│   ├── CONFIGURATION.md          # Config customization guide
│   └── BLUEPRINT-V2.md           # Development blueprint
├── action.yml                    # GitHub Action definition
├── scalpel.config.json           # Default extensible config
├── install.sh                    # One-command plug-in (auto-detects agent)
├── uninstall.sh                  # Zero-trace removal
├── CHANGELOG.md                  # Version history
├── CONTRIBUTING.md               # Contribution guide
├── LICENSE                       # MIT
└── README.md
```

<br>

## ⚙️ Configuration

Customize every aspect of Scalpel with `scalpel.config.json`:

```json
{
  "scan": {
    "custom": [{ "name": "a11y-audit", "command": "npx axe-linter src/", "scoring": { "pass": 5 } }]
  },
  "team": {
    "custom_roles": [{ "name": "i18n-specialist", "trigger": "i18n/ directory exists" }]
  },
  "scoring": {
    "custom_rules": [{ "name": "no-console", "check": "grep -rn console src/components/", "deduction": -5 }]
  }
}
```

Full reference: [docs/CONFIGURATION.md](docs/CONFIGURATION.md)

<br>

## 🤝 Contributing

Scalpel is open source and built for the community. Contributions welcome:

- **New scan dimensions** — accessibility, i18n, GraphQL, mobile
- **Stack-specific configs** — Next.js, Django, Rails, Rust, Flutter, Laravel
- **Adapter improvements** — better Cursor, Windsurf, Aider support
- **Scoring rules** — new quality violations to catch
- **Community configs** — share your `scalpel.config.json` in [awesome-scalpel](https://github.com/anupmaster/awesome-scalpel)

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

<br>

## 📜 License

[MIT](LICENSE) — Use it however you want.

<br>

## 💡 Philosophy

> *"Understand everything before touching anything."*

The biggest failure mode in AI-assisted development isn't bad code generation — it's **good code generation without context**. An AI that writes perfect TypeScript but doesn't know you use Zustand instead of Redux, or deploys to Railway instead of Vercel, or follows conventional commits instead of squash merges, will create technically correct code that's **architecturally wrong**.

Scalpel makes **project intelligence** the first step, not an afterthought.

---

<p align="center">
  <strong>If Scalpel saved you time, consider giving it a star.</strong><br>
  <sub>It helps other developers find this tool.</sub>
</p>

<p align="center">
  <a href="https://github.com/anupmaster/scalpel/stargazers"><img src="https://img.shields.io/github/stars/anupmaster/scalpel?style=social" alt="Star"></a>
</p>

<p align="center">
  <sub>Created by <a href="https://github.com/anupmaster"><strong>Anup Karanjkar</strong></a> &middot; <a href="https://anupkaranjkar.com">anupkaranjkar.com</a></sub>
</p>
