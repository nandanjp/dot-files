# dotfiles

Configuration for a macOS (Apple Silicon) dev machine. Records the live state of
the machine, not a historical snapshot.

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
| `gitconfig` | `~/.gitconfig` | |
| `nvim/` | `~/.config/nvim` | `lazy-lock.json` is pinned |
| `tmux/` | `~/.config/tmux` | tpm and 5 plugins vendored — no install step |
| `kitty/` | `~/.config/kitty` | wants `MesloLGS Nerd Font Mono` |
| `git/` | `~/.config/git` | global ignore, picked up automatically |
| `claude/` | `~/.claude` | see [claude/README.md](claude/README.md) |

## Keeping it current

`brew bundle` installs what's listed but never removes what isn't, so add
entries as you install. To see drift:

```
$ brew bundle check --file=Brewfile --verbose   # listed but missing
$ brew leaves                                   # installed but maybe unlisted
$ brew list --cask
```

These files are **copied** into place, not symlinked, so editing `~/.zshrc` does
not update the repo. Copy back:

```
$ cp ~/.zshrc .                    # note: lands as .zshrc, rename
$ cp -R ~/.config/{nvim,tmux,kitty,git} .
```

## Related

`~/scripts` holds what isn't machine configuration: `bookmarks.txt`,
`brew_upgrade.sh`, and an identical copy of this repo's `Brewfile`.
