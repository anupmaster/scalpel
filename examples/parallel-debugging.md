# Example: Parallel Hypothesis Debugging

## Scenario

Your auth flow is broken — users log in successfully but get redirected to `/login` instead of `/dashboard`. 
The bug appeared after a recent deployment. You don't know the root cause.

## Session

```bash
> Scalpel, skip recon. Debug: users get redirected to /login after successful auth instead of /dashboard.
```

## What Happens

Scalpel runs a **targeted** Phase 1 (only auth-related files), then spawns:

```
Surgical team assembled for debugging:

  Investigator 1: Hypothesis A (Redirect Logic)
    → Checking middleware.ts, auth.config.ts, callback URLs

  Investigator 2: Hypothesis B (Session/Cookie Issue)  
    → Checking session config, cookie settings, CSRF tokens

  Investigator 3: Hypothesis C (Recent Deploy Change)
    → Checking git diff of last 5 commits, env var differences

  Each investigator will actively try to DISPROVE their own theory.
```

## Result

```
╔══════════════════════════════════════════════════════════════╗
║  🔪 SCALPEL — Diagnostic Result                             ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Root Cause: Hypothesis C confirmed.                         ║
║                                                              ║
║  Last deploy changed NEXTAUTH_URL from                       ║
║  "https://app.example.com" to "https://app.example.com/"    ║
║  (trailing slash). Auth.js callback comparison fails on      ║
║  exact match, causing redirect loop to /login.               ║
║                                                              ║
║  Evidence: Investigator 3 found the env var diff.            ║
║  Investigators 1 & 2 ruled out their hypotheses.             ║
║                                                              ║
║  Fix: Remove trailing slash from NEXTAUTH_URL                ║
║  in Vercel environment variables.                            ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```
