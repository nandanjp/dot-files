---
name: feedback-manual-steps-over-generated-scripts
description: For machine setup work Nandan wants a manual step-by-step guide he drives himself, not a bootstrap script that does it for him.
metadata:
  type: feedback
---

I proposed an idempotent staged `bootstrap.sh` for the 2026-09 laptop rebuild. He
replied: "Instead of creating a script with staged steps to configure this laptop, I
want a manual step by step." The result was `REBUILD.md` — phases, copy-pasteable
commands, and a *Verify* check closing each phase.

**Why:** he wants to see and approve each step as it happens, and to understand the
machine he is building rather than inherit a black box. The verify-per-phase shape
is what makes that work — he runs a step, confirms the result, then moves on.

**How to apply:** default to a written procedure over automation for setup and
migration work. Keep each phase small enough to verify, state ordering constraints
explicitly (and *why* the order matters), and flag traps inline rather than leaving
them to be discovered. Running individual commands on his behalf is welcome once a
step is agreed — the objection is to batching, not to assistance. See
[[feedback-run-only-the-scope-asked]].
