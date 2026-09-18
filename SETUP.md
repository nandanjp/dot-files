# New machine setup

Takes a fresh macOS install to the state this repo records. Work top to bottom —
the order matters where flagged. Language toolchains live in
**[LANGUAGES.md](LANGUAGES.md)**.

Legend: `$` = terminal · 🖐 = manual/GUI step

---

## Phase 0 — Prerequisites

```
$ xcode-select --install
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Homebrew doesn't put itself on PATH; use `/opt/homebrew/bin/brew` until Phase 4
installs `zprofile`.

**Verify:** `/opt/homebrew/bin/brew --version`

---

## Phase 1 — Git identity and SSH

**Order: first.** Later phases clone over `git@github.com:`.

```
$ ssh-keygen -t ed25519 -C "nandan.jp17@gmail.com"      # accept the default path
```

Create `~/.ssh/config` so the key loads from Keychain on every boot:

```
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

```
$ eval "$(ssh-agent -s)"
$ ssh-add --apple-use-keychain ~/.ssh/id_ed25519
$ pbcopy < ~/.ssh/id_ed25519.pub
```

🖐 Paste into **github.com → Settings → SSH and GPG keys → New SSH key**.

**Verify:** `ssh -T git@github.com`

---

## Phase 2 — Rust and Haskell

**Order: before `brew bundle`.** The Brewfile's five `cargo` entries need rustup,
and Neovim's Mason list needs ghcup.

Follow **[LANGUAGES.md § Rust](LANGUAGES.md#rust)** and
**[§ Haskell](LANGUAGES.md#haskell)**, then come back.

**Verify:**

```
$ cargo --version                        # must resolve to ~/.cargo/bin
$ which -a rustc                         # exactly ONE path
$ ls ~/.ghcup/env
$ ls ~/.zshrc                            # must NOT exist yet — Phase 4 creates it
```

---

## Phase 3 — Homebrew bundle

```
$ git clone git@github.com:nandanjp/dotfiles.git ~/dotfiles
$ brew bundle install --file=~/dotfiles/Brewfile
```

Expect password prompts for the casks, and one expected failure: `npm "corepack"`
has no npm yet. Let it fail — Phase 5 fixes it.

**Verify:** `brew bundle check --file=~/dotfiles/Brewfile --verbose` — everything
except the corepack line comes back satisfied.

---

## Phase 4 — Shell

### 4.1 Missing zsh plugin

`zshrc:29` sources `zsh-cargo-completion`, which isn't a Homebrew formula. Clone
it or every shell start errors:

```
$ mkdir -p ~/.zsh/plugins
$ git clone https://github.com/MenkeTechnologies/zsh-cargo-completion.git \
    ~/.zsh/plugins/zsh-cargo-completion
```

### 4.2 Install the shell config

```
$ cp ~/dotfiles/zshrc     ~/.zshrc
$ cp ~/dotfiles/zshenv    ~/.zshenv
$ cp ~/dotfiles/zprofile  ~/.zprofile
$ cp ~/dotfiles/gitconfig ~/.gitconfig
```

The prompt config isn't in this repo — generate it with the wizard:

```
$ p10k configure
```

**Verify:** open a fresh terminal, no startup errors, and:

```
$ exec zsh
$ ll              # eza with icons and a git column
$ echo $EDITOR    # nvim
```

---

## Phase 5 — Node

```
$ fnm install --lts
$ fnm default lts-latest
$ exec zsh
$ corepack enable
```

Then retry the entry that failed in Phase 3:

```
$ brew bundle install --file=~/dotfiles/Brewfile
```

**Verify:** `node --version && npm --version && pnpm --version`

---

## Phase 6 — XDG configs

Copy each directory whole — this brings the vendored tmux plugins too, so there
is no tpm install step.

```
$ mkdir -p ~/.config
$ cp -R ~/dotfiles/nvim  ~/.config/nvim
$ cp -R ~/dotfiles/tmux  ~/.config/tmux
$ cp -R ~/dotfiles/kitty ~/.config/kitty
$ cp -R ~/dotfiles/git   ~/.config/git
```

⚠️ If the destination already exists, `cp -R` copies *inside* it. Kitty creates
`~/.config/kitty` on first launch, so check the depth and flatten if needed:

```
$ ls ~/.config/kitty/kitty.conf          # not .../kitty/kitty/kitty.conf
$ mv ~/.config/kitty/kitty/* ~/.config/kitty/
```

### 6.1 tmux

```
$ tmux source ~/.config/tmux/tmux.conf
```

**Verify:** start `tmux` — Catppuccin Mocha status bar, prefix is `Ctrl-Space`.

### 6.2 Neovim

**Order: last**, after Node (Phase 5) and Go (Phase 3) — eight of the 14 Mason
servers are npm packages. Use `:Lazy restore`, never `:Lazy sync`.

```
$ nvim
```

**Verify:** `:Lazy` (all installed, no errors), `:Mason`, `:checkhealth`

### 6.3 kitty

Needs `MesloLGS Nerd Font Mono` from Phase 3 (`font-meslo-lg-nerd-font`). Boxes
instead of glyphs means that cask didn't land.

---

## Phase 7 — Claude Code

Single profile at `~/.claude`, default `CLAUDE_CONFIG_DIR`. Detail in
**[claude/README.md](claude/README.md)**.

```
$ mkdir -p ~/.claude
$ cp ~/dotfiles/claude/settings.json ~/.claude/settings.json
$ git clone git@github.com:nandanjp/claude-skills.git ~/.claude/skills
```

Plugins — don't copy `installed_plugins.json`, it points at cache directories
that aren't in any repo:

```
$ claude plugin marketplace add anthropics/claude-plugins-official
$ claude plugin install gopls-lsp@claude-plugins-official
$ claude plugin install frontend-design@claude-plugins-official
```

```
$ claude auth login --email nandan.jp17@gmail.com
```

**Verify:** `/plugin` shows both plugins enabled, `/skills` lists 11.

---

## Phase 8 — GUI apps 🖐

Phase 3 installed these; each still needs a sign-in or restore.

| App | What's needed |
|---|---|
| **Tailscale** | Sign in, re-authorize this machine in the tailnet |
| **Docker Desktop** | First launch, accept terms, enable shell completions |
| **Anki** | Sync from AnkiWeb |
| **VS Code** | Sign in for Settings Sync; extensions already installed |
| **Raycast** | Sign in, re-import custom commands and hotkeys |
| **Termius** | Sign in — SSH hosts live in its own sync |
| **Discord** | Sign in |
| **Zen / Chrome** | Sign in, then import `~/scripts/bookmarks.txt` |

---

## Not in this repo

- `~/.ssh/*` — regenerated in Phase 1
- `~/.zsh_history`
- `~/.config/raycast/` — **deliberately excluded**, contains a live auth token in
  `aster-endpoint.json`. Regenerate it from the extension; don't commit it.
- Raycast custom commands, Termius hosts, VS Code settings not covered by Sync
