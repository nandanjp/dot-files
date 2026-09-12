---
name: project-spending-open-followups
description: Deferred decisions in the spending CLI — recurring threshold, merchant truncation, ruff config, store-number merging.
metadata:
  type: project
---

Known-and-accepted gaps as of 2026-09-09, each raised and consciously left open
rather than overlooked:

- **`recurring()` finds nothing on Amex.** Not a bug — the export spans ~6 weeks
  (2026-07-22 to 2026-09-05) and detection needs 3+ occurrences, which a monthly
  subscription can't reach in that window. I suggested lowering the threshold to
  2 when a file's span is under ~90 days; the user didn't take it up. The
  `recent()` report's "Seen" column surfaces the same repeats meanwhile.
- **Truncated merchants can't be reunited.** Amex's 24-char field yields both
  `CAL - COCO FRESH TEA` and `COCO FRESH TEA & JUICE` for one brand. Fixing this
  needs a merchant dictionary, not another rule.
- **Store numbers are merged deliberately** (`WAL-MART 3151` + `WAL-MART 3010` →
  `WAL-MART`), so chain branches report as one merchant. Reversible by dropping
  the pure-digit rule in `_is_reference` if per-store detail is ever wanted.
- **No linter config in `pyproject.toml`.** `ruff` is on PATH and `ruff check`
  passes, but `ruff format --check` would reformat `cli.py`, `tests/test_formats.py`
  and `tests/test_reports.py`. Left untouched because ruff defaults aren't an
  established standard in this repo; offered to add a `[tool.ruff]` section.

**Why:** Each of these looks like an oversight on a fresh read and risks being
"fixed" or re-reported as a finding.

**How to apply:** Don't re-raise these as new discoveries. Treat them as
available work the user has already seen. See [[project-spending-data-files-change]]
— a longer Amex export resolves the recurring one on its own.
