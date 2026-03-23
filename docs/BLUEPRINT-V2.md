# SCALPEL v2.0 — Development Blueprint
## Codename: "The Surgeon Upgrade"

**Status:** Ready for Claude Code Agent Team Execution
**Base:** v1.0 (live on GitHub, working, validated)
**Goal:** 10,000+ GitHub stars through genuine utility, not marketing tricks
**Philosophy:** Plug → Analyze → Enhance → Solve → Boost → Unplug

---

## UPDATE SAFETY GUARANTEE

Before building anything new, this constraint governs ALL v2 decisions:

### The Contract With Existing Users

Anyone who installed Scalpel v1.0 via symlink, direct copy, or global install
MUST NOT experience breakage when v2.0 ships. This means:

1. **Activation phrases remain identical.** "Hi Scalpel", "Scalpel start", "Scalpel scan" — unchanged.
2. **Phase 1-5 protocol remains intact.** v2 ADDS capabilities. It never removes or reorders phases.
3. **No new runtime dependencies.** v1 is pure markdown. v2's agent file remains pure markdown.
   New features (CLI scanner, GitHub Action) are SEPARATE files that don't affect the agent.
4. **Symlink users get v2 automatically** on `git pull`. This is safe because:
   - The agent file only contains INSTRUCTIONS for Claude, not executable code
   - Nothing runs until the user explicitly activates Scalpel
   - New features are additive (new phases append, existing phases untouched)
5. **Semantic versioning enforced:**
   - v1.x → backward compatible enhancements
   - v2.0 → new features, but v1 activation and phases preserved
   - v3.0 → if we ever need breaking changes (migration guide required)

---

## WHAT v2 ADDS (The Complete Enhancement Map)

v2 transforms Scalpel from "a Claude Code agent" into "a universal codebase intelligence platform."

```
v1.0 (Current)                          v2.0 (This Blueprint)
─────────────────                        ──────────────────────
One agent file (scalpel.md)      →       Agent + Standalone CLI Scanner
Claude Code only                 →       7 agent adapters (Codex, Gemini, Cursor...)
One-shot sessions                →       Persistent memory across sessions
Manual activation only           →       + /loop continuous monitoring
Flat text reconnaissance         →       Structured project knowledge model
Fixed scoring rules              →       Extensible scoring via scalpel.config.json
No CI/CD integration             →       GitHub Action for PR health checks
No token optimization            →       Effort-level routing (low for scan, high for surgery)
No post-surgery interaction      →       "Talk to any surgeon" after completion
```

---

## v2 ARCHITECTURE — The Complete File Map

```
scalpel/
├── src/
│   ├── scalpel.md                    # v2 agent brain (enhanced, backward-compatible)
│   ├── scanner.sh                    # Standalone bash scanner (zero AI, zero tokens)
│   └── adapters/
│       ├── codex.md                  # Codex CLI adapter
│       ├── gemini.md                 # Gemini CLI adapter
│       ├── cursor.cursorrules        # Cursor rules format
│       ├── windsurf.md               # Windsurf rules format
│       ├── aider.md                  # Aider conventions format
│       └── opencode.md              # OpenCode agent config
├── install.sh                        # One-command plug-in (enhanced)
├── uninstall.sh                      # Zero-trace removal (unchanged)
├── scalpel.config.json               # Extensible configuration schema
├── docs/
│   ├── SPECIFICATION.md              # Full technical spec (from v1)
│   ├── BLUEPRINT-V2.md               # THIS FILE — development plan
│   ├── CONFIGURATION.md              # How to customize Scalpel
│   └── UPDATE-SAFETY.md              # Version compatibility guarantees
├── examples/
│   ├── nextjs-ecommerce.md           # (from v1)
│   ├── parallel-debugging.md         # (from v1)
│   ├── scan-only-health-check.md     # (from v1)
│   ├── python-django-api.md          # NEW: Python project example
│   └── inherited-codebase.md         # NEW: "I just inherited this" scenario
├── .github/
│   └── workflows/
│       └── scalpel-scan.yml          # GitHub Action for PR health checks
├── CONTRIBUTING.md                   # Enhanced with v2 contribution paths
├── CHANGELOG.md                      # NEW: version history
├── LICENSE                           # MIT (unchanged)
└── README.md                         # v2 README (enhanced, not rewritten)
```

---

## ENHANCEMENT 1: STANDALONE SCANNER — "The Gateway Drug"

### Why This Is P0

The Codebase Vitals report is Scalpel's most shareable artifact. Currently it's
locked inside a Claude Code conversation. Extracting it into a standalone bash
script that runs WITHOUT any AI agent means:

- Zero tokens consumed (pure bash + git + grep + find + wc)
- Zero Claude subscription required
- Runs on ANY machine with bash and git
- Outputs to terminal, JSON, or CI format
- Becomes the viral screenshot that drives GitHub stars

### File: `src/scanner.sh`

A self-contained bash script (~300 lines) that performs ALL of Phase 1's
12-dimension diagnostic using only standard Unix tools.

### Scanner Output Modes

```bash
./scanner.sh                    # Pretty terminal output (Vitals box)
./scanner.sh --json             # Machine-readable JSON
./scanner.sh --ci               # GitHub Actions annotation format
./scanner.sh --markdown         # Markdown report (for PR comments)
./scanner.sh --score-only       # Just the number: "64"
```

### What The Scanner Detects (Pure Bash, Zero AI)

```
DIMENSION              DETECTION METHOD
─────────────────────  ──────────────────────────────────────────────
Project DNA            Read package.json/pyproject.toml/Cargo.toml
                       Parse framework from dependencies list
                       Count deps, detect monorepo config files

Architecture           Count files by extension (.ts, .tsx, .py, .rs)
                       Detect App Router vs Pages Router (Next.js)
                       Count 'use client' directives

Git Forensics          git log, git branch -a, git remote -v
                       git log --diff-filter=D (deleted files)
                       git shortlog -sn (contributor count)
                       git stash list (hidden WIP)

Infrastructure         Test -f for Dockerfile, docker-compose.yml
                       Detect CI: .github/workflows/, .gitlab-ci.yml
                       Detect deploy: vercel.json, fly.toml, railway.json

Database               Detect ORM: prisma/, drizzle.config, models/
                       Count migration files
                       Read schema for table count

Testing                Count test files: *.test.*, *.spec.*, test_*
                       Detect runner config: vitest, jest, pytest
                       Read coverage config if present

Security               grep for exposed patterns: sk_live, AKIA, password=
                       Check npm audit / pip audit output
                       Detect .env files without .gitignore entry

Code Quality           Detect ESLint, Prettier, Husky configs
                       Check TypeScript strict mode
                       Count TODO/FIXME/HACK comments with file locations

Performance            Measure directory sizes (node_modules, .next, dist)
                       Count 'use client' vs server components ratio
                       Check for bundle analyzer config

Documentation          Check README.md exists and length
                       Check /docs directory
                       Count JSDoc comments

Agent Ecosystem        Check CLAUDE.md, .claude/agents/, .cursorrules
                       Check .mcp.json, .claudeignore
                       List existing agent configurations
```

### Health Score Algorithm (Deterministic, Reproducible)

```
CATEGORY                 POINTS   CONDITION
────────────────────     ──────   ─────────────────────────────────
Test Infrastructure       +15     At least 1 test file exists
Test Coverage             +5      Test file count > 10% of source files
CI/CD Pipeline            +10     .github/workflows/ or equivalent exists
No Exposed Secrets        +10     Zero grep hits for secret patterns
TypeScript Strict         +5      "strict": true in tsconfig.json
Linting Configured        +5      ESLint or equivalent config exists
Formatting Enforced       +3      Prettier or equivalent config exists
Pre-commit Hooks          +2      Husky or lint-staged configured
README Exists             +5      README.md > 50 lines
API Documentation         +5      OpenAPI spec or /docs directory exists
JSDoc Coverage            +3      > 20 JSDoc comments found
Git Health                +5      Regular commits (> 1/week avg), clean branches
No TODO Overload          +5      < 20 TODO/FIXME comments
No Dead Code              +5      < 10 unused exports detected
Error Handling            +5      Try/catch or error boundary patterns found
Env Documented            +3      .env.example exists
Deps Up-to-date           +4      No known CVEs in dependencies
Bundle Optimized          +5      First-load JS < 200KB or no bundle concern
────────────────────     ──────
TOTAL                     100

RATING SCALE:
90-100  Excellent — Production-grade, well-maintained
75-89   Good — Solid foundation, minor gaps
60-74   Needs Improvement — Significant gaps to address
40-59   At Risk — Multiple critical issues
0-39    Critical — Major intervention required
```

### Scanner Integration With Agent

When Scalpel (the agent) activates, Phase 1 calls the scanner FIRST:
```
Phase 1 Step 1: Run scanner.sh --json → parse structured data
Phase 1 Step 2: Use AI ONLY for nuanced analysis the scanner can't do
                (architecture pattern recognition, code quality assessment)
```

This means Phase 1 uses 70% fewer tokens because the heavy lifting (file
counting, grep patterns, git commands) is done by bash, not by the LLM.
The LLM only interprets the results.


---

## ENHANCEMENT 2: TOKEN OPTIMIZATION ENGINE

### The Problem

v1 uses Opus for everything — reconnaissance, team design, monitoring. That's
like paying a brain surgeon to take your blood pressure. Wasteful.

### The Solution: Effort-Level Routing

```
PHASE              EFFORT    MODEL         WHY
──────────────     ──────    ──────────    ────────────────────────────────
Phase 1 Scan       low       sonnet        File reading = mechanical, not creative
Phase 2 Questions  high      opus          Strategic questioning = deep reasoning
Phase 3 Assembly   high      opus          Team design = architectural thinking
Phase 4 Operate    medium    sonnet        Spawned agents do implementation work
Phase 4 Monitor    low       sonnet        Score checking = pattern matching
Phase 5 Report     medium    sonnet        Report generation = structured output
```

### Implementation In Agent Frontmatter

```yaml
---
name: scalpel
description: [unchanged]
tools: [unchanged]
model: opus
effort: low          # START low for Phase 1 (scanner does the heavy work)
---
```

Within the agent prompt, Phase 2-3 instructions include:
"Switch to high effort reasoning for the following strategic analysis..."

This is possible because effort can be modulated per-turn within a session,
not just at session start. The frontmatter sets the DEFAULT, and specific
phases override it contextually.

### Projected Token Savings

```
v1 (all Opus, all high effort):    ~45,000 tokens per full session
v2 (effort-routed + scanner.sh):   ~18,000 tokens per full session
Savings:                           ~60% reduction
```

The scanner.sh handles 70% of Phase 1 work in zero tokens.
Effort routing handles the remaining 30% at low cost.
High-effort Opus only activates for Phases 2-3 (the brain work).


---

## ENHANCEMENT 3: PERSISTENT SESSION MEMORY — "Scalpel Gets Smarter"

### The Problem

v1 Scalpel starts fresh every session. It has zero memory of previous work.
If you ran Scalpel yesterday and fixed tests, today it will suggest fixing
tests again because it doesn't know they were already addressed.

### The Solution: `.scalpel/memory.jsonl`

After every session, Scalpel appends one line to a persistent JSONL file:

```jsonl
{"v":"2","ts":"2026-03-23T12:00:00Z","project":"wowhow","health_before":48,"health_after":74,"team_size":4,"duration_min":18,"priorities_fixed":["tests","security"],"priorities_remaining":["bundle_size","dead_code"],"agent_scores":[95,88,92,100],"files_created":16,"files_modified":9}
{"v":"2","ts":"2026-03-24T09:00:00Z","project":"wowhow","health_before":74,"health_after":86,"team_size":3,"duration_min":12,"priorities_fixed":["bundle_size"],"priorities_remaining":["dead_code","docs"],"agent_scores":[90,95,100],"files_created":4,"files_modified":7}
```

### How It Changes Behavior

On session start, after Phase 1 scan, Scalpel reads memory.jsonl and:

1. **Skips re-diagnosing fixed issues:** "Tests were addressed in the last session
   (health improved 48→74). Skipping test infrastructure."
2. **Continues from remaining priorities:** "Remaining from last session: bundle_size,
   dead_code. Let me verify current state and continue."
3. **Tracks health trajectory:** "Over 2 sessions, health improved 48→74→86.
   At this rate, one more session reaches 90+ (Excellent)."
4. **Learns agent performance:** "Agent scores averaged 93 last session.
   The team composition worked well — reusing similar roles."

### Memory Is Project-Scoped

The memory file lives at `.scalpel/memory.jsonl` inside each project.
Different projects have independent memories. When you unplug Scalpel
(uninstall.sh), the memory is deleted. Zero trace.

### Memory Schema

```json
{
  "v": "2",                              // Schema version for forward-compat
  "ts": "ISO-8601 timestamp",
  "project": "string (directory name)",
  "health_before": 0-100,
  "health_after": 0-100,
  "team_size": 1-6,
  "duration_min": number,
  "priorities_fixed": ["string array"],
  "priorities_remaining": ["string array"],
  "agent_scores": [number array],
  "files_created": number,
  "files_modified": number
}
```

---

## ENHANCEMENT 4: MULTI-AGENT ADAPTERS — "Works With Everything"

### The Problem

v1 only works with Claude Code. That limits our audience to Claude Code users
(~5% of AI-assisted developers). Codex CLI, Gemini CLI, Cursor, Windsurf,
Aider, and OpenCode users are excluded.

### The Solution: Adapter Files

Each adapter translates Scalpel's agent protocol into the target tool's format.
The CORE LOGIC is identical — only the delivery format changes.

### Adapter Strategy

```
TOOL           FORMAT              FILE LOCATION
──────────     ──────────────      ──────────────────────────────
Claude Code    .md with YAML       src/scalpel.md (primary, exists)
Codex CLI      AGENTS.md format    src/adapters/codex.md
Gemini CLI     System prompt       src/adapters/gemini.md
Cursor         .cursorrules        src/adapters/cursor.cursorrules
Windsurf       .windsurfrules      src/adapters/windsurf.md
Aider          .aider.conf.yml     src/adapters/aider.md
OpenCode       agent config        src/adapters/opencode.md
```

### Adapter Content Strategy

Each adapter contains:
1. The same 12-dimension scan instructions (tool-agnostic — it's bash commands)
2. The same Vitals report format
3. The same team assembly logic
4. Tool-specific formatting (how to call bash, how to read files, etc.)

The adapters are NOT full rewrites. They are thin translation layers:
~80% shared content (scan protocol, report format, team logic)
~20% tool-specific glue (file reading syntax, command execution format)

### install.sh Enhancement

The installer auto-detects the coding agent and installs the right adapter:

```bash
# Auto-detection logic in install.sh
if command -v claude &> /dev/null; then
  # Install to .claude/agents/
elif [ -f ".cursorrules" ] || command -v cursor &> /dev/null; then
  # Append to .cursorrules
elif command -v codex &> /dev/null; then
  # Install to AGENTS.md
elif command -v gemini &> /dev/null; then
  # Install to system prompt config
fi
```


---

## ENHANCEMENT 5: CONTINUOUS MONITORING VIA /loop — "The Codebase Guardian"

### The Problem

v1 Scalpel is a one-shot tool. It operates, delivers a report, and goes silent.
If a developer introduces a regression 30 minutes later, Scalpel doesn't know.

### The Solution: Post-Surgery Monitoring Mode

After Phase 5 delivery, Scalpel offers:

```
Surgery complete. Health improved 48 → 74.

Want me to monitor for regressions? I'll run a lightweight health check
every 30 minutes and alert you if anything degrades.

Options:
  1. Yes, monitor every 30 min (recommended)
  2. Yes, monitor every hour
  3. No, I'll call you when needed
```

If the user accepts, Scalpel issues:
```
/loop 30m Run scanner.sh silently. Compare health score against last
known score (74). If score drops by more than 5 points, alert immediately
with: which files changed, what degraded, and suggested fix.
```

### What The Monitor Checks (Lightweight, Fast)

Every cycle runs scanner.sh (pure bash, zero tokens) and compares:
- Health score delta (current vs last known)
- New TODO/FIXME count vs previous
- Build status (does tsc --noEmit still pass?)
- New files without tests
- New dependencies without lockfile update

If everything is stable: silent (no output, no token cost).
If regression detected: ONE alert with specific file + issue + suggestion.

### Token Cost: Nearly Zero

The /loop runs scanner.sh (bash, zero tokens). LLM tokens are ONLY
consumed when a regression is detected and Scalpel needs to explain it.
99% of monitoring cycles cost zero tokens.

---

## ENHANCEMENT 6: POST-SURGERY INTERACTIVE Q&A — "Talk To Any Surgeon"

### The Problem

v1 delivers a report and ends. Users can't ask WHY a specific decision
was made. The context is lost.

### The Solution

After Phase 5 delivery report, Scalpel adds:

```
Want to understand any decision? Ask me:
  "Why did Surgeon 2 refactor auth.ts this way?"
  "What alternatives did the Quality Guardian consider?"
  "Show me the diff from Surgeon 3's worktree"
```

This works because the team lead (Scalpel) has access to:
- Each surgeon's task list entries (what they reported)
- The git diff from each worktree
- The Quality Guardian's review findings

The user can interrogate the decisions before accepting the changes.
This turns a one-way delivery into a two-way exploration.

### Implementation

This requires NO new tooling. It's purely a prompt addition in the
Phase 5 section of scalpel.md. After presenting the report, Scalpel
offers the interactive prompt and responds based on the context it
already has from monitoring Phase 4.


---

## ENHANCEMENT 7: EXTENSIBLE CONFIGURATION — "The Platform Play"

### The Problem

v1 has hardcoded scanning rules, fixed team templates, and static scoring.
Power users can't customize Scalpel for their stack, their standards, or
their industry.

### The Solution: scalpel.config.json

A project-level configuration file that lets users and communities extend
every dimension of Scalpel's behavior:

```json
{
  "$schema": "https://raw.githubusercontent.com/anupmaster/scalpel/main/schemas/config.schema.json",
  "version": "2.0",
  "scan": {
    "dimensions": {
      "include": ["all"],
      "exclude": ["performance"],
      "custom": [
        {
          "name": "accessibility-audit",
          "description": "WCAG 2.2 compliance check",
          "command": "npx axe-linter --reporter json src/ 2>/dev/null",
          "scoring": { "pass": 5, "fail": 0 }
        }
      ]
    },
    "ignore_paths": ["vendor/", "generated/", "migrations/"],
    "secret_patterns": ["RAZORPAY_KEY_SECRET", "SUPABASE_SERVICE_ROLE"]
  },
  "team": {
    "max_agents": 5,
    "default_model": "sonnet",
    "architect_model": "opus",
    "custom_roles": [
      {
        "name": "i18n-specialist",
        "trigger": "project has i18n/ or messages/ directory",
        "jurisdiction": ["src/i18n/**", "messages/**", "src/locales/**"],
        "prompt": "You specialize in internationalization..."
      }
    ]
  },
  "scoring": {
    "custom_rules": [
      {
        "name": "no-console-in-components",
        "check": "grep -rn 'console\\.' --include='*.tsx' src/components/",
        "deduction": -5,
        "message": "Console statements found in React components"
      }
    ],
    "thresholds": {
      "excellent": 90,
      "good": 75,
      "needs_improvement": 60,
      "at_risk": 40
    }
  },
  "monitoring": {
    "interval_minutes": 30,
    "alert_threshold": 5,
    "auto_start": false
  }
}
```

### Community Ecosystem Path

Phase 1: Ship scalpel.config.json support in v2
Phase 2: Create `awesome-scalpel` companion repo
Phase 3: Community contributes stack-specific configs:
  - scalpel-nextjs (Next.js optimized scanning + teams)
  - scalpel-django (Python/Django patterns)
  - scalpel-rails (Ruby on Rails conventions)
  - scalpel-rust (Cargo-aware scanning)
  - scalpel-laravel (PHP/Laravel patterns)
  - scalpel-flutter (Dart/Flutter mobile patterns)
  - scalpel-india (GST compliance, DPDPA policy checks, UPI integration checks)

Each community config is a single JSON file. Users drop it in and Scalpel
adapts to their stack. This is how "tool" becomes "platform."


---

## ENHANCEMENT 8: GITHUB ACTION — "PR Health Gate"

### File: `.github/workflows/scalpel-scan.yml`

A GitHub Action that runs scanner.sh on every pull request and posts
the Codebase Vitals report as a PR comment.

### What It Does

1. Runs on: `pull_request` events
2. Checks out the code
3. Runs `scanner.sh --json` on the PR branch
4. Runs `scanner.sh --json` on the base branch
5. Computes delta: "This PR changes health score from 74 → 71 (-3)"
6. Posts a formatted comment on the PR with:
   - Before/after health score
   - New TODOs introduced
   - New files without tests
   - Security pattern matches
7. Optionally blocks merge if score drops below threshold

### Usage For End Users

```yaml
# In their project's .github/workflows/scalpel.yml
name: Scalpel Health Check
on: [pull_request]
jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0    # Full history for git forensics
      - uses: anupmaster/scalpel-action@v1
        with:
          fail-below: 60    # Block merge if health drops below 60
          comment: true     # Post Vitals as PR comment
```

### Why This Matters For Stars

Once Scalpel is in a team's CI/CD pipeline, it becomes infrastructure.
Infrastructure doesn't get uninstalled. Every team that adds the GitHub
Action becomes a permanent user. And every PR comment with the Scalpel
Vitals box is free advertising to every reviewer on that team.

---

## SCALPEL.MD v2 — THE AGENT BRAIN UPGRADE

### What Changes From v1

The v2 agent file is an ADDITIVE enhancement. Nothing is removed.
Here are the specific additions to each phase:

### Phase 0 (NEW) — Pre-Flight Check

Before Phase 1, Scalpel now:
1. Checks if `.scalpel/memory.jsonl` exists → reads previous session data
2. Checks if `scalpel.config.json` exists → loads custom configuration
3. Checks if `scanner.sh` is available → uses it for Phase 1 acceleration
4. Reports: "Returning to [project]. Last session: [date], health: [score]."
   OR: "First time analyzing [project]. Running full diagnostic."

### Phase 1 Enhancement — Scanner Integration

```
BEFORE (v1): LLM reads every file, runs every grep → ~30,000 tokens
AFTER  (v2): scanner.sh does 70% of work → LLM interprets results → ~9,000 tokens
```

Phase 1 now executes:
1. Run `scanner.sh --json` → get structured diagnostic data
2. Parse JSON output for all 12 dimensions
3. Use LLM ONLY for: architecture pattern recognition, code quality
   assessment, and generating the human-readable Vitals report
4. Apply custom dimensions from scalpel.config.json if present

### Phase 2 Enhancement — Memory-Aware Questions

If memory.jsonl exists, Phase 2 questions become:
- "Last session fixed [X]. Current scan shows [Y] is now the top priority. Agree?"
- "Health trajectory: 48→74→86 over 2 sessions. One more session should reach 90+."

Instead of asking generic diagnostic questions, Scalpel asks CONTINUATION questions.

### Phase 5 Enhancement — Post-Surgery Options

After the delivery report, Scalpel now offers three paths:

```
Surgery complete. What's next?

  1. "Monitor"  — Start /loop monitoring for regressions
  2. "Debrief"  — Ask any surgeon about their decisions
  3. "Done"     — End session (memory saved automatically)
```

This replaces the abrupt v1 ending with an interactive close-out.


---

## FASTER TEAM GENERATION — "Spawn In Seconds, Not Minutes"

### The Problem In v1

When Scalpel spawns a surgical team, each agent gets a massive context dump
including the FULL Phase 1 data. This wastes tokens and slows spawn time.

### The v2 Approach: Compressed Intelligence Briefs

Instead of giving each surgeon the full diagnostic data, Scalpel generates
a **compressed intelligence brief** per surgeon containing ONLY:

1. Their file jurisdiction (exactly which files they own)
2. The relevant subset of Phase 1 findings for their scope
3. Project conventions that affect their work (from Phase 1)
4. Their specific acceptance criteria

Example for "API Surgeon" (instead of full 12-dimension dump):

```
INTELLIGENCE BRIEF — API Surgeon
Project: wowhow (Next.js 14, TypeScript strict, Prisma + Supabase)
Your Jurisdiction: src/app/api/**, src/lib/api/**, src/server/**
Forbidden: src/components/**, src/app/(routes)/**
Conventions: zod validation on all routes, conventional commits
Current Issues: 3 API routes missing error handling, 2 without auth middleware
Acceptance: All routes have try/catch + zod + auth. tsc --noEmit passes.
```

This is ~200 tokens instead of ~3,000 tokens per surgeon.
For a 4-surgeon team: 800 tokens instead of 12,000 tokens.
**85% reduction in spawn cost.**

### Implementation

In Phase 3, after designing the team but before spawning:
1. For each surgeon role, extract ONLY the Phase 1 dimensions relevant to their scope
2. Compress into the structured brief format above
3. Pass the brief (not the full dump) when spawning via Task tool

---

## SELF-IMPROVEMENT BETWEEN SESSIONS

### How Scalpel Gets Better Over Time

Using memory.jsonl data across sessions:

```
Session 1: Health 48 → 74 (tests fixed)
Session 2: Health 74 → 86 (bundle optimized)
Session 3: Health 86 → 93 (dead code removed)
Session 4: Health 93 → 96 (docs improved, final polish)
```

By Session 3, Scalpel knows:
- Which team compositions worked (scores per role)
- Which priorities yield the highest health improvement per token spent
- Which issues the user cares about (they keep saying "yes" to) vs which
  they skip (they say "not now" to)

Scalpel uses this to optimize:
- **Team composition:** "Builder agents scored 95 avg. Tester agents scored 82.
  Adding more context to tester briefs."
- **Priority ordering:** "User always prioritizes tests over docs. Reordering."
- **Session planning:** "3 more sessions at current trajectory reaches 100.
  Recommending: dead code → API docs → changelog."

This is NOT hallucinated prediction. It's simple arithmetic on real JSONL data.


---

## DEVELOPMENT EXECUTION PLAN — For Claude Code Agent Teams

### How To Use This Blueprint

Open this project in VS Code with Claude Code. Then:

```
claude --dangerously-skip-permissions

> Read docs/BLUEPRINT-V2.md completely. Then execute the development
  phases in order using agent teams with worktree isolation.
```

### PHASE A: Scanner Engine (Day 1, ~4 hours)

**What to build:** `src/scanner.sh` — the standalone bash diagnostic tool

**Agent Team:**
```
Teammate 1: "Scanner Core" — Builds the 12-dimension bash scanner
  Jurisdiction: src/scanner.sh
  Acceptance: scanner.sh runs on macOS + Linux, outputs valid JSON,
              produces the Vitals box in terminal mode

Teammate 2: "Scanner Tests" — Validates scanner on sample projects
  Jurisdiction: tests/scanner/
  Acceptance: Scanner produces correct output on 3 sample project
              structures (Next.js, Python, empty repo)
```

**Deliverables:**
- `src/scanner.sh` (~300 lines, pure bash, zero dependencies)
- Scanner handles missing tools gracefully (no crash if `tree` not installed)
- JSON output schema documented
- Terminal output matches the Vitals box format from README

### PHASE B: Agent Brain v2 (Day 1, ~3 hours)

**What to build:** Enhanced `src/scalpel.md` with all v2 features

**Agent Team:**
```
Teammate 1: "Brain Surgeon" — Upgrades scalpel.md
  Jurisdiction: src/scalpel.md
  Acceptance: All v1 activation phrases work. Phase 0 added.
              Scanner integration in Phase 1. Memory in Phase 0/5.
              Post-surgery options in Phase 5. /loop offer in Phase 5.

Teammate 2: "Config Designer" — Creates scalpel.config.json schema
  Jurisdiction: scalpel.config.json, schemas/
  Acceptance: Valid JSON Schema. Example config file works.
              Agent reads and applies custom dimensions + scoring.
```

**Deliverables:**
- Updated `src/scalpel.md` with Phase 0 + scanner integration + memory + monitoring + debrief
- `scalpel.config.json` example file with documentation
- `schemas/config.schema.json` for validation

### PHASE C: Multi-Agent Adapters (Day 2, ~4 hours)

**What to build:** 6 adapter files for non-Claude-Code agents

**Agent Team:**
```
Teammate 1: "Adapter Builder" — Creates all 6 adapter files
  Jurisdiction: src/adapters/
  Acceptance: Each adapter contains the full Scalpel protocol
              translated to the target tool's format

Teammate 2: "Installer Upgrade" — Enhances install.sh with auto-detection
  Jurisdiction: install.sh, uninstall.sh
  Acceptance: install.sh detects Claude Code / Codex / Cursor / Gemini
              and installs the correct adapter automatically
```

**Deliverables:**
- 6 adapter files in `src/adapters/`
- Enhanced `install.sh` with agent auto-detection
- Enhanced `uninstall.sh` that cleans up any adapter format

### PHASE D: GitHub Action + CI/CD (Day 2, ~3 hours)

**What to build:** Reusable GitHub Action

**Agent Team:**
```
Teammate 1: "Action Builder" — Creates the GitHub Action
  Jurisdiction: .github/workflows/, action.yml
  Acceptance: Action runs scanner.sh on PR branches,
              computes delta vs base, posts PR comment

Teammate 2: "Docs + README" — Updates README and docs for v2
  Jurisdiction: README.md, docs/CONFIGURATION.md, CHANGELOG.md
  Acceptance: README reflects all v2 features. Changelog exists.
              Configuration guide covers scalpel.config.json.
              "Built in one session" narrative in README.
              Super-individual tagline added.
```

**Deliverables:**
- `action.yml` at repo root (makes it a usable GitHub Action)
- `.github/workflows/scalpel-scan.yml` (example workflow)
- Updated README.md with v2 features, narrative, and diagrams
- New `CHANGELOG.md`
- New `docs/CONFIGURATION.md`


---

## PHASE E: QUALITY ASSURANCE & INTEGRATION (Day 3, ~2 hours)

**What to verify:**
```
1. scanner.sh runs on macOS (zsh) + Linux (bash) without errors
2. scanner.sh --json produces valid JSON on:
   - A Next.js project
   - A Python project
   - An empty git repo
   - A non-git directory
3. scalpel.md v2 activates with all v1 phrases
4. Memory file creates/reads/appends correctly
5. install.sh auto-detects at least 3 agent types
6. uninstall.sh leaves truly zero trace
7. All adapters contain the complete Scalpel protocol
8. GitHub Action runs in a test workflow
9. README renders correctly on GitHub (no broken badges, no broken links)
10. git tag v2.0.0 + GitHub Release created
```

---

## README v2 ENHANCEMENTS — What To Add, Not Rewrite

### ADD to top (below badges):
```
> Built in one Claude Code session by a solo founder.
> One developer. A full surgical team. Zero employees.
```

### ADD after Quick Start:
```
## 🔍 Standalone Scanner (Zero AI, Zero Tokens)

Don't want to use an AI agent? Just want the diagnostic?

  ./scalpel/src/scanner.sh          # Terminal output
  ./scalpel/src/scanner.sh --json   # Machine-readable

No subscription. No API keys. No tokens. Pure bash.
```

### ADD to Works With table:
All 7 agents with "Full Support" and adapter links

### ADD to bottom:
```
## 🔄 What's New in v2

- Standalone scanner — zero AI, zero tokens codebase diagnostic
- 60% fewer tokens — effort-level routing + scanner acceleration
- Persistent memory — Scalpel gets smarter with each session
- 7 agent adapters — Claude Code, Codex, Gemini, Cursor, Windsurf, Aider, OpenCode
- Continuous monitoring — /loop regression detection
- Post-surgery Q&A — ask any surgeon about their decisions
- GitHub Action — automated PR health checks
- Extensible config — customize scanning, teams, and scoring
```

---

## DISTRIBUTION STRATEGY (Post-Ship, Not Part of Build)

After v2 is pushed to GitHub:

### Week 1 — Seed
- Star your own repo
- Submit to awesome-agent-skills, awesome-claude-code-toolkit
- Post on r/ClaudeAI, r/ChatGPTCoding, r/webdev, r/SideProject
- Medium article: "I Built an AI Surgeon for Codebases in One Session"
- X/Twitter thread with Vitals screenshot (scan a famous OSS project)

### Week 2 — Amplify
- Run scanner.sh on popular repos, screenshot results, tag maintainers
- Submit to Hacker News: "Show HN: Scalpel — Zero-token codebase diagnostic + AI surgical teams"
- Create video demo (2 min): plug in → scan → team spawns → results
- Submit GitHub Action to GitHub Marketplace

### Week 3 — Ecosystem
- Launch awesome-scalpel companion repo
- First community configs: scalpel-nextjs, scalpel-django
- Open "good first issue" labels for contributors

---

## SUCCESS METRICS

```
METRIC                          TARGET          TRACKING
─────────────────────           ──────          ────────────────
GitHub Stars                    10,000+         Weekly check
Forks                           500+            Weekly check
scanner.sh standalone users     1,000+          Download count
GitHub Action installations     100+            Marketplace stats
Community configs submitted     10+             awesome-scalpel PRs
Medium article claps            1,000+          Medium analytics
Reddit upvotes (launch post)    500+            Post stats
Hacker News front page          1 day           HN tracking
```

---

## THE CORE PROMISE (Never Lose Sight Of This)

Scalpel exists because:

**AI coding agents are powerful but context-blind.**

They don't know your architecture. They don't know your deploy target.
They don't know your git history. They don't know your tech debt.
They don't know your team's conventions.

So they guess. And guessing at scale = bugs at scale.

Scalpel gives ANY coding agent deep project intelligence BEFORE it
writes a single line of code. That's the entire product.

Everything in this blueprint — the scanner, the memory, the adapters,
the config, the Action, the monitoring — serves ONE purpose:

**Make the intelligence deeper, faster, cheaper, and available everywhere.**

Plug → Analyze → Enhance → Solve → Boost → Unplug.

---

*This blueprint is ready for execution. Open this project in Claude Code
and paste: "Read docs/BLUEPRINT-V2.md and execute Phase A."*
