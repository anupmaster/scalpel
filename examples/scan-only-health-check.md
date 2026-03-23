# Example: Scan-Only Mode (Codebase Health Check)

## Scenario

You just inherited a codebase from a previous developer. Before touching anything, you want to understand what you're working with.

## Session

```bash
> Scalpel scan
```

## What Happens

Scalpel runs Phase 1 and Phase 2 ONLY. No team assembly. No code changes. Pure diagnostic.

You get:
1. The full Codebase Vitals report
2. A list of every framework, library, and tool in use (with versions)
3. Git forensics: who worked on this, when, what was deleted, what's abandoned
4. Tech debt inventory: every TODO, FIXME, and HACK with file locations
5. Security scan: exposed secrets, outdated deps with CVEs
6. Infrastructure map: where it deploys, what CI runs, what services it connects to

## Why This Matters

This is the **screenshot moment**. The Vitals report is something developers will screenshot and share:
- "Look what I found when I ran Scalpel on our inherited codebase"
- "47 TODOs, zero tests, 3 abandoned branches, and 2 CVEs. Fun."
- "Scalpel found our staging env vars hardcoded in middleware.ts"

Even if you never spawn a surgical team, the diagnostic alone justifies the install.
