<p align="center">
  <h1 align="center">🔪 Scalpel</h1>
  <p align="center">
    <strong>Surgical AI for your codebase.</strong><br>
    Diagnose. Assemble. Operate. Zero side effects.
  </p>
  <p align="center">
    <a href="#-quick-start"><img src="https://img.shields.io/badge/Get_Started-30_seconds-brightgreen?style=for-the-badge" alt="Get Started"></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="MIT License"></a>
    <a href="#-works-with"><img src="https://img.shields.io/badge/Works_With-Any_AI_Agent-purple?style=for-the-badge" alt="Works With"></a>
  </p>
</p>

<br>

> **Scalpel** plugs into any project like a USB forensic toolkit. It performs a deep diagnostic scan of your entire codebase — git history, architecture, dependencies, infrastructure, tech debt — then assembles a custom AI surgical team calibrated to YOUR project. When done, unplug it. Zero trace. Zero residue. Just improved code.

<br>

```bash
# Plug into any project. 30 seconds.
cd your-project
npx scalpel-ai init

# Inside Claude Code / Codex / Gemini CLI:
> Hi Scalpel, start work
```

<br>

## 🩺 What Happens When You Say "Hi Scalpel"

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   Phase 1 — DIAGNOSE (2 min, fully autonomous)                  │
│   Scalpel silently scans 12 dimensions of your project:         │
│   stack, architecture, git forensics, database, auth,           │
│   infrastructure, tests, integrations, tech debt, and more.     │
│                                                                 │
│   Phase 2 — CONSULT                                             │
│   Delivers a Codebase Vitals report, then asks 5-7              │
│   surgical questions that ONLY you can answer.                  │
│                                                                 │
│   Phase 3 — ASSEMBLE                                            │
│   Designs a custom surgical team based on YOUR project.         │
│   Not a template. Adaptive specialists with file jurisdiction.  │
│                                                                 │
│   Phase 4 — OPERATE                                             │
│   Spawns parallel agents in isolated worktrees.                 │
│   Monitors quality. Scores each agent. Corrects drift.          │
│                                                                 │
│   Phase 5 — CLOSE                                               │
│   Integration verification. Full delivery report.               │
│   Unplug Scalpel. Zero trace remains.                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

<br>

## 📊 The Codebase Vitals Report

After scanning, Scalpel produces a shareable diagnostic:

```
╔══════════════════════════════════════════════════════════════╗
║  🔪 SCALPEL — Codebase Vitals                               ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Project    : acme-dashboard                                 ║
║  Stack      : Next.js 14 · TypeScript · Tailwind · Prisma   ║
║  Database   : PostgreSQL via Supabase (23 tables, 4 views)   ║
║  Auth       : Auth.js v5 (Google + GitHub OAuth)             ║
║  Deploy     : Vercel (CI: GitHub Actions, 3 workflows)       ║
║  Tests      : 0 files ⛔ CRITICAL                            ║
║  Tech Debt  : 47 TODOs · 12 FIXMEs · 3 HACKs                ║
║  Git Health : 1,247 commits · 5 branches · 3 contributors    ║
║  Bundle     : 847KB first load ⚠️  above 200KB threshold     ║
║  Security   : 2 deps with known CVEs                         ║
║  Dead Code  : 14 unused exports detected                     ║
║                                                              ║
║  ┌────────────────────────────────────────────────────┐      ║
║  │  HEALTH SCORE                                      │      ║
║  │  ████████████████░░░░░░░░  64/100                  │      ║
║  │  Needs Improvement                                 │      ║
║  └────────────────────────────────────────────────────┘      ║
║                                                              ║
║  Top 3 Priorities:                                           ║
║  1. Add test infrastructure (0% coverage)                    ║
║  2. Fix 2 security vulnerabilities in dependencies           ║
║  3. Reduce bundle size (tree-shake unused imports)           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

> 💡 **This report alone is worth the install.** Run `scalpel scan` on any codebase to get an instant health check — no AI agents needed.

<br>

## ⚡ Quick Start

### Option 1: npx (Recommended)

```bash
cd your-project
npx scalpel-ai init       # Detects your stack, drops config
```

### Option 2: Global Install (Available in every project)

```bash
# Copy agent to user-level directory
mkdir -p ~/.claude/agents
curl -fsSL https://raw.githubusercontent.com/anupmaster/scalpel/main/src/scalpel.md \
  -o ~/.claude/agents/scalpel.md

# Now available in every Claude Code session
```

### Option 3: Portable Pendrive (Symlink)

```bash
git clone https://github.com/anupmaster/scalpel.git ~/tools/scalpel

# Plug into any project
cd your-project && ~/tools/scalpel/install.sh

# Unplug when done
~/tools/scalpel/uninstall.sh    # Zero trace
```

### Then:

```bash
# Start your coding agent
claude                          # or codex, gemini-cli, opencode

# Activate Scalpel
> Hi Scalpel, start work
```

<br>

## 🔬 Works With

| Agent | Status | How |
|-------|--------|-----|
| **Claude Code** | ✅ Full Support | Native `.claude/agents/` integration |
| **Codex CLI** | ✅ Full Support | Via agent instructions |
| **Gemini CLI** | ✅ Full Support | Via system prompt injection |
| **OpenCode** | ✅ Full Support | Via agent config |
| **Cursor** | 🔄 Partial | Via `.cursorrules` adapter |
| **Windsurf** | 🔄 Partial | Via rules adapter |
| **Aider** | 🔄 Partial | Via conventions file |

> Scalpel's reconnaissance engine is pure bash + git. It works everywhere. The orchestration layer adapts to your agent.

<br>

## 🧠 Why Scalpel Exists

**The problem:** AI coding agents are powerful but context-blind. They don't know your architecture, your deployment target, your git history, your tech debt, or your team's conventions. So they guess. And guessing at scale = bugs at scale.

**The solution:** Scalpel gives any AI coding agent **deep project intelligence** before it writes a single line of code. It's the difference between a surgeon who studies the patient's chart vs. one who walks in blind.

| Without Scalpel | With Scalpel |
|----------------|-------------|
| Agent guesses your stack | Agent KNOWS your stack, versions, and patterns |
| Agent edits random files | Agent has assigned file jurisdiction — no conflicts |
| Single agent, sequential | Parallel surgical team, monitored and scored |
| No awareness of tech debt | Full tech debt inventory, prioritized |
| No awareness of git history | Reads deleted files, abandoned branches, commit patterns |
| Generic "build me X" | Contextual "build X using YOUR patterns in YOUR architecture" |

<br>

## 🏗️ The 12-Dimension Diagnostic

Scalpel's Phase 1 scans these dimensions automatically:

| # | Dimension | What It Discovers |
|---|-----------|------------------|
| 1 | **Project DNA** | Framework, language, dependencies, versions, monorepo structure |
| 2 | **Architecture** | Entry points, routing, data flow, state management, styling |
| 3 | **Git Forensics** | Commit velocity, branching strategy, deleted files, abandoned work |
| 4 | **Infrastructure** | Docker, CI/CD, deployment target, reverse proxy, IaC |
| 5 | **Database** | ORM, schema, migrations history, seed data, table count |
| 6 | **Testing** | Runner, coverage, E2E scenarios, test health |
| 7 | **Auth & Security** | Provider, protected routes, RBAC, API key management |
| 8 | **Integrations** | Payments, email, storage, analytics, monitoring |
| 9 | **Agent Ecosystem** | Existing CLAUDE.md, agents, commands, MCP servers, hooks |
| 10 | **Code Quality** | Linting rules, formatting, pre-commit hooks, strict mode |
| 11 | **Performance** | Bundle size, image optimization, caching, rendering strategy |
| 12 | **Documentation** | README, API docs, JSDoc coverage, ADRs |

<br>

## 🔪 Adaptive Surgical Teams

Scalpel doesn't use a fixed agent template. It designs a team based on what YOUR project needs:

```
Project has DB + API + Frontend?
→ Data Layer Surgeon · API Surgeon · Frontend Surgeon · Quality Guardian

Frontend-heavy SaaS?
→ Component Architect · State Specialist · Performance Surgeon · Quality Guardian

Drowning in tech debt?
→ Debt Liquidator · Test Surgeon · Dependency Modernizer · Quality Guardian

Early-stage prototype?
→ Foundation Builder · Test Infrastructure · CI/CD Architect · Quality Guardian
```

Each teammate gets:
- **File jurisdiction** — explicit list of files they own (prevents merge conflicts)
- **Forbidden zones** — files they must NEVER touch
- **Worktree isolation** — parallel execution without interference
- **Quality score** — starts at 100, deductions for violations, terminated at < 50

<br>

## 🧮 Agent Scoring System

Scalpel monitors every teammate in real-time:

| Violation | Deduction |
|-----------|-----------|
| Modified file outside jurisdiction | -10 |
| Broke the build | -15 |
| Used `any` type or skipped error handling | -10 |
| Left `console.log` in production code | -5 |
| Introduced a regression | -20 |
| Ignored established project patterns | -10 |

**Score < 70** → Scalpel re-issues instructions with corrections.  
**Score < 50** → Scalpel terminates the agent and redistributes work.

<br>

## 🔌 The Pendrive Principle

Scalpel is designed like a **forensic USB toolkit**:

```
✅ Plug in  → scalpel init (or install.sh)
✅ Do work  → Scalpel scans, assembles team, operates
✅ Plug out → scalpel remove (or uninstall.sh)
✅ Zero trace — your git history never shows Scalpel was there
```

**What Scalpel NEVER touches:**
- Your existing `CLAUDE.md` (reads only, never overwrites)
- Your existing agents, commands, or settings (reads only)
- Your `package.json` (never adds dependencies)
- Your git history (never commits itself)

**What Scalpel leaves behind:**
- The actual code improvements your team delivered
- That's it. Nothing else.

<br>

## 📂 Project Structure

```
scalpel/
├── src/
│   └── scalpel.md           # The agent brain
├── install.sh                # One-command plug-in
├── uninstall.sh              # One-command plug-out (zero trace)
├── docs/
│   ├── SPECIFICATION.md      # Full technical specification
│   ├── CONFIGURATION.md      # Customization guide
│   └── EXAMPLES.md           # Real-world usage examples
├── examples/
│   ├── nextjs-project/       # Example config for Next.js
│   ├── python-api/           # Example config for FastAPI/Django
│   └── rust-cli/             # Example config for Rust projects
├── CONTRIBUTING.md           # How to contribute
├── LICENSE                   # MIT
└── README.md                 # You are here
```

<br>

## 🤝 Contributing

Scalpel is open source and welcomes contributions:

- **Add reconnaissance dimensions** — new scanners for frameworks, languages, or tools
- **Add agent templates** — surgical team patterns for specific project types
- **Add scoring rules** — new quality violations to detect
- **Improve adapters** — better support for Cursor, Windsurf, Aider

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

<br>

## 📜 License

[MIT](LICENSE) — Use it however you want. No restrictions.

<br>

## 💡 Philosophy

> "Understand everything before touching anything."

Scalpel exists because the biggest failure mode in AI-assisted development isn't bad code generation — it's **good code generation without context**. An AI that writes perfect TypeScript but doesn't know you use Zustand instead of Redux, or deploys to Railway instead of Vercel, or follows conventional commits instead of squash merges, will create technically correct code that's architecturally wrong.

Scalpel eliminates this by making **project intelligence** the first step, not an afterthought.

<br>

---

<p align="center">
  <sub>Built by <a href="https://github.com/anupmaster">@anupmaster</a> · Powered by <a href="https://absomind.com">Absomind Technologies</a></sub>
</p>
