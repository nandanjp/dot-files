---
name: project-laptop-rebuild-2026-09
description: The 2026-09-11 MacBook rebuild — what got installed, the single-profile decision, and the three things still outstanding.
metadata:
  type: project
---

Rebuilt a new MacBook on 2026-09-11 from a temporary snapshot at `~/scripts` (now
deleted). Phases 0–7 and 9 are done; the procedure and every trap hit along the way
are recorded in `REBUILD.md` at the repo root — read it before redoing any of this.

Decisions that aren't obvious from the files:

- **The personal/Ridgeway split was removed entirely.** The old machine ran separate
  `~/.claude-personal` and `~/.claude-ridge` profiles with zsh wrapper functions
  swapping `CLAUDE_CONFIG_DIR`. Now a single `~/.claude`, one git identity
  (`nandan.jp17@gmail.com`), and the wrappers are deleted from the zshrc. Don't
  reintroduce per-account config without asking.
- **`~/dotfiles` was built from the live machine, not the snapshot**, so it records
  what survived the trims rather than what the old laptop had.
- **LaTeX was deferred, not dropped.** `basictex` and `james-yu.latex-workshop` sit
  commented in the Brewfile; see "Deferred work" in `REBUILD.md` for the `latexmk`
  trap before re-enabling.

Still outstanding as of 2026-09-11:

1. **Phase 8** — GUI sign-ins, none done: Tailscale, Docker Desktop, Anki (AnkiWeb
   sync), VS Code Settings Sync, Raycast, Termius, Discord, and importing
   `bookmarks.txt` into Zen/Chrome.
2. **`~/dotfiles` has no remote.** Needs a private `nandanjp/dotfiles` on GitHub and
   a first push. It supersedes the old `nandanjp/dot-files`, whose local copy is gone.
3. **The Raycast endpoint token was deliberately not carried over** — regenerate it
   from the extension rather than restoring the old value.

**Why:** each of these looks like an oversight on a fresh read. They are known and
intentional. See [[user-lean-evidence-based-tooling]] for how the trims were decided.
