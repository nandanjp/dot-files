---
name: user-lean-evidence-based-tooling
description: Nandan trims toolchains hard and decides from evidence of actual use — present what depends on what, not a list to approve.
metadata:
  type: user
---

Across the 2026-09 rebuild he cut every list well past what I proposed: casks 20→13,
formulae 27→15 (then 14), VS Code extensions 29→12, cargo crates 10→5, Go tools 7→2.
He removed `llvm` with his own reasoning ("the LDFLAGS/CPPFLAGS is a rust
optimization that is not necessarily needed anymore"), and deferred LaTeX rather than
carry a half-working setup.

What made those decisions fast was evidence, not description. Grepping `~/projects`
for real consumers — no `build.zig` so Zig went, no `.proto` files so protobuf went,
no `Chart.yaml` so helm went, Prometheus already running in-cluster so the local one
went — turned a 27-item list into three quick answers. He also engages with a
recommendation directly rather than deferring: told that Neovim's 15 Mason LSPs
duplicate most VS Code extensions, he chose the lean 12 immediately.

**How to apply:** before offering a keep/drop list, search the actual tree for each
item's consumer and lead with that finding. Separate the load-bearing entries (what a
config `source`s or an alias calls) from the discretionary ones, because he treats
those differently — the first group isn't up for debate, the second is. Give a
recommendation with reasoning attached; he will override it with his own context and
expects that to be taken without re-argument. Related:
[[feedback-run-only-the-scope-asked]].
