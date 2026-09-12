---
name: feedback-design-discussion-before-refactor
description: For architectural work, Nandan wants the design pattern discussed and options weighed before any code is written.
metadata:
  type: feedback
---

For anything architectural, present the design and the trade-offs first, then
implement after agreement. The user opened the bank-agnostic refactor with
"Let's think about what design pattern would be appropriate here and then work
through a refactor" — discussion was an explicit prerequisite, not a preamble.

**Why:** The user proposed a parent/subclass `Transaction` hierarchy. Writing it
as asked would have shipped a design where reports had to `isinstance`-check to
reach bank-specific fields — defeating the stated goal. Laying out the trade-off
first (and offering flat-canonical / ABC / Protocol as real options with code
previews) let them pick Protocol + per-bank dataclasses deliberately.

**How to apply:** Name the patterns explicitly — this user thinks in them and
engages with the tradeoffs. Push back with the concrete failure mode rather than
a general principle, then still offer their original framing as a real option.
Use AskUserQuestion with code previews for the forking decision. Once they
choose, implement fully without re-litigating. See
[[project-spending-open-followups]].
