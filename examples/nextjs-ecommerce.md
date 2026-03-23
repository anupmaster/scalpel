# Example: Scalpel on a Next.js Project

## Scenario

You have a Next.js 14 e-commerce storefront with Supabase, Auth.js, and Razorpay. 
The project has grown organically — no tests, scattered TODOs, and a few abandoned feature branches.

## Session

```bash
# Plug Scalpel in
cd ~/Projects/my-store
~/tools/scalpel/install.sh

# Launch Claude Code
claude --dangerously-skip-permissions

# Activate
> Hi Scalpel, start work
```

## What Happens

### Phase 1 Output (Codebase Vitals)

```
╔══════════════════════════════════════════════════════════════╗
║  🔪 SCALPEL — Codebase Vitals                               ║
╠══════════════════════════════════════════════════════════════╣
║  Project    : my-store                                       ║
║  Stack      : Next.js 14 · TypeScript · Tailwind · Prisma   ║
║  Database   : PostgreSQL via Supabase (18 tables)            ║
║  Auth       : Auth.js v5 (Google + Email magic link)         ║
║  Deploy     : Vercel (CI: GitHub Actions)                    ║
║  Tests      : 0 files ⛔                                     ║
║  Tech Debt  : 34 TODOs · 8 FIXMEs                            ║
║  Git Health : 456 commits · 7 branches (3 stale)             ║
║  Security   : 1 dep with known CVE (next-auth@4.x)          ║
║                                                              ║
║  HEALTH SCORE: 48/100 — Needs Serious Attention              ║
╚══════════════════════════════════════════════════════════════╝
```

### Phase 2 Questions

Scalpel asks:
1. "Branch `feature/admin-panel` has 23 commits but was never merged. Continue or abandon?"
2. "Razorpay integration exists but no webhook handler. Is live payment active?"
3. "Priority: new features, bug fixes, tests, or tech debt cleanup?"

### Phase 3 Team (after user says "tests and tech debt")

```
Surgical team assembled:

  Surgeon 1: Test Infrastructure — owns tests/, vitest.config.ts
  Surgeon 2: API Test Coverage — owns tests for app/api/**
  Surgeon 3: Tech Debt Liquidator — owns TODO/FIXME resolution
  Guardian:  Quality Guardian — read-only review

Approve?
```

### Phase 5 Report (after completion)

```
╔══════════════════════════════════════════════════════════════╗
║  🔪 SCALPEL — Surgical Report                               ║
╠══════════════════════════════════════════════════════════════╣
║  Duration    : 18 minutes                                    ║
║  Surgeon 1   : Test Infra — vitest + 4 config files — 95/100║
║  Surgeon 2   : API Tests — 12 test files, 47 cases — 88/100 ║
║  Surgeon 3   : Debt — resolved 28/34 TODOs — 92/100         ║
║  Guardian    : 2 suggestions, 0 critical issues              ║
║                                                              ║
║  Files Created  : 16                                         ║
║  Files Modified : 9                                          ║
║  Tests Added    : 47                                         ║
║  Build Status   : ✅ PASSING                                  ║
║  Health Score   : 48 → 74 (+26 improvement)                  ║
╚══════════════════════════════════════════════════════════════╝
```

## Unplug

```bash
~/tools/scalpel/uninstall.sh
# Zero trace. Only the 16 new files and 9 improved files remain.
```
