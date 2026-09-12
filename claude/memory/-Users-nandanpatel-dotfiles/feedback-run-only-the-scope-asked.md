---
name: feedback-run-only-the-scope-asked
description: When Nandan names a specific subset to install or act on, run exactly that subset — don't execute the broader command that contains it.
metadata:
  type: feedback
---

On 2026-09-11 Nandan said "can you run the singular installation to install these
formulas?" after we had curated the formula list. I ran `brew bundle install`, which
installs the *whole* Brewfile — so 28 VS Code extensions and 10 cargo crates began
installing alongside the 15 formulae. He stopped it: "We did a bit too much here. I
only wanted to install the formulas."

**Why:** the named subset was the deliverable, not a convenient label for the whole
file. Running the containing command is a scope expansion even when it reaches the
same end state, because it spends his time and machine on things he hadn't decided
about yet — and here it forced an uninstall pass to undo.

**How to apply:** when he names a category (formulae, casks, extensions), find or
construct the command that does only that category, or say plainly that the tool
can't scope it and ask before running the broader one. This is the same instinct
behind [[feedback-manual-steps-over-generated-scripts]] — he wants to approve each
unit of work, not hand over a batch. Related: [[user-lean-evidence-based-tooling]].
