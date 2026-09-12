---
name: project-spending-repo-uncommitted
description: The spending repo has zero git commits and data/ holds real financial statements; whether to version them is undecided.
metadata:
  type: project
---

As of 2026-09-09 the `spending` repo (branch `master`, no `main` yet) has **zero
commits** — every file is untracked. All work through the bank-agnostic refactor
exists only in the working tree.

`data/` is not gitignored and holds real personal statements: Wealthsimple
chequing rows with an account id (`WK57HRS38CAD`), and Amex rows with merchant
names, cities, and reference numbers. Committing them would put real financial
data in git history permanently.

**Why:** I flagged this and offered to make an initial commit; the user said "good
for now" without deciding. So it is an open question, not a settled choice.

**How to apply:** Before any first commit, ask whether `data/` should be tracked,
gitignored, or replaced with synthetic samples. Don't commit it silently. Note
that `tests/test_integration.py` parametrizes over whatever is in `data/`, so
gitignoring those files makes that suite skip rather than fail. See
[[project-spending-data-files-change]].
