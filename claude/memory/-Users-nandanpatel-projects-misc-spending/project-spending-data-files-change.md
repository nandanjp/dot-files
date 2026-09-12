---
name: project-spending-data-files-change
description: The CSVs in spending/data/ are live re-exports whose schema changes between sessions — always re-inspect before analyzing.
metadata:
  type: project
---

The files in `data/` are re-downloaded bank exports, not fixtures. They change
shape underneath the code without warning.

On 2026-09-09, mid-session, `data/amex-all-time.csv` went from **14 columns to
4** (`Date`, `Date Processed`, `Description`, `Amount`) and from 20 rows to 51.
The dropped `Merchant` column was in `AmexFormat.REQUIRED`, so header sniffing
matched nothing and the file stopped loading entirely.

**Why:** Any conclusion drawn from an earlier reading of these files can be stale
or wrong by the next request. The user's own phrasing was that it had "changed
slightly" — the change was in fact structural.

**How to apply:** Re-read the header and row count before analyzing anything in
`data/`. Never reuse cached row counts or totals across turns. When adding a
format, put only genuinely stable columns in `REQUIRED` — it is a subset check,
so keeping it minimal is what lets one format absorb both a wide and a slim
export shape. Same for hardcoded totals in tests: assert invariants instead.
