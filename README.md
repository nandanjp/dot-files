# dotfiles

Configuration for a macOS (Apple Silicon) dev machine. This is the source of
truth — it records the live state of the machine, not a historical snapshot.

## Setting up a new machine

Start at **[SETUP.md](SETUP.md)**. It runs top to bottom and defers to
**[LANGUAGES.md](LANGUAGES.md)** for the language toolchains.

## What's here

| Path | Installs to | Notes |
|---|---|---|
| `Brewfile` | — | `brew bundle install --file=Brewfile` |
| `zshrc` | `~/.zshrc` | |
| `zshenv` | `~/.zshenv` | sources `~/.cargo/env`; read *before* `zprofile` |
| `zprofile` | `~/.zprofile` | runs `brew shellenv` |
| `gitconfig` | `~/.gitconfig` | identity, `init.defaultBranch`, `pull.rebase` |
| `p10k.zsh` | `~/.p10k.zsh` | generated — re-run `p10k configure`, don't hand-edit |
| `nvim/` | `~/.config/nvim` | lazy.nvim + Mason, `lazy-lock.json` is pinned |
| `tmux/` | `~/.config/tmux` | tpm and 5 plugins are vendored — no install step |
| `kitty/` | `~/.config/kitty` | wants `MesloLGS Nerd Font Mono` |
| `git/` | `~/.config/git` | global ignore file, picked up automatically |
| `claude/` | `~/.claude` | settings + project memory; see [claude/README.md](claude/README.md) |

## What's deliberately not here

- **`~/.config/raycast/`** — holds `aster-endpoint.json`, a live auth token.
- **`~/.ssh/`** — keys are regenerated per machine (SETUP.md Phase 1).
- **Rust.** There is no `brew "rust"` in the Brewfile, on purpose. See
  [LANGUAGES.md § Rust](LANGUAGES.md#rust).
- **Claude Code skills** — their own repo, `nandanjp/claude-skills`, cloned into
  `~/.claude/skills`.
- **Claude Code runtime state** — `sessions/`, `daemon/`, `telemetry/`,
  `history.jsonl` and friends. Not worth restoring; some of it holds session keys.

## Keeping it current

`brew bundle` installs what's listed but never removes what isn't, so the
Brewfile only stays accurate if you add entries as you install. To see drift:

```
$ brew bundle check --file=Brewfile --verbose   # listed but missing
$ brew leaves                                   # installed but maybe unlisted
$ brew list --cask
```

Config changes flow the other way — these files are **copied** into place, not
symlinked, so editing `~/.zshrc` does not update the repo. Copy back:

```
$ cp ~/.zshrc ~/.p10k.zsh .        # note: lands as .zshrc/.p10k.zsh, rename
$ cp -R ~/.config/{nvim,tmux,kitty,git} .
```

## Related

`~/scripts` holds what isn't machine configuration: `bookmarks.txt`,
`brew_upgrade.sh`, and a Brewfile kept as the **full historical superset** —
every cask ever installed, including ones not on this machine.

Its `claude/` snapshot was verified against the live `~/.claude` and folded into
`claude/` here on 2026-09-12, then deleted.
