# New machine setup

Everything needed to take a fresh macOS install to the state this repo records.

Companion doc: **[LANGUAGES.md](LANGUAGES.md)** — the language toolchains, which
this guide defers to in Phase 2 and Phase 5.

Work top to bottom. The order matters in four places, each flagged with **Order**.
Every phase ends with a *Verify* — don't move on until it passes.

Legend: `$` = run in terminal · 🖐 = manual/GUI step · ⚠️ = known trap

---

## Phase 0 — Prerequisites

```
$ xcode-select --install
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Homebrew on Apple Silicon installs to `/opt/homebrew` and does **not** put itself
on PATH. Phase 4 installs this repo's `zprofile`, which is the file that runs
`brew shellenv`. Until then, use the full path `/opt/homebrew/bin/brew`.

**Verify:** `/opt/homebrew/bin/brew --version`

---

## Phase 1 — Git identity and SSH

**Order:** first. Later phases clone over `git@github.com:` and all fail without
a key on GitHub.

`gitconfig` in this repo holds the identity, so Phase 4 covers it. What can't be
committed is the key:

```
$ ssh-keygen -t ed25519 -C "nandan.jp17@gmail.com"
```

⚠️ Type that command, don't paste a line containing `eval "$(ssh-agent -s)"` into
a prompt expecting a filename — that produces a keypair named after the command
string, which is how two stray key files ended up in `~/scripts` on the last
rebuild. Accept the default path.

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

**Verify:** `ssh -T git@github.com` → "Hi nandanjp! You've successfully authenticated"

---

## Phase 2 — Rust and Haskell

⚠️ **Order:** before `brew bundle`. The Brewfile has five `cargo "..."` entries
and **no rust formula** — deliberately, see LANGUAGES.md § Rust. Run the bundle
first and all five fail. Neovim's Mason list needs ghcup for the same reason.

Follow **[LANGUAGES.md § Rust](LANGUAGES.md#rust)** and
**[§ Haskell](LANGUAGES.md#haskell)**, then come back.

**Verify:**

```
$ cargo --version                        # must resolve to ~/.cargo/bin
$ which -a rustc                         # exactly ONE path
$ ls ~/.ghcup/env                        # zshrc keys off this file existing
$ ls ~/.zshrc                            # must NOT exist yet — Phase 4 creates it
```

---

## Phase 3 — Homebrew bundle

16 formulae, 14 casks, 12 VS Code extensions, 2 Go tools, 5 cargo crates, 1 uv,
1 npm.

```
$ git clone git@github.com:nandanjp/dotfiles.git ~/dotfiles
$ brew bundle install --file=~/dotfiles/Brewfile
```

⚠️ **Expected failure: `npm "corepack"`.** There is no npm yet — Node arrives via
fnm in Phase 5, which is itself installed by this bundle run. Let the line fail;
Phase 5 fixes it. Nothing else depends on it.

⚠️ This installs 14 casks, so expect password prompts.

⚠️ **`brew bundle` never removes.** If you later `brew install` something and
want to keep it, add it to the Brewfile in the same breath or the file drifts.

The casks that were on the pre-2026-09 machine but not reinstalled here are kept
on record in `~/scripts/Brewfile`, the historical superset.

**Verify:** `brew bundle check --file=~/dotfiles/Brewfile --verbose` — everything
except the corepack line comes back satisfied.

---

## Phase 4 — Shell

### 4.1 Missing zsh plugin

⚠️ `zshrc:29` sources `zsh-cargo-completion`, which is not a Homebrew formula. A
missing `source` target prints an error on **every** shell start (a missing
`fpath` entry, by contrast, is silently ignored).

```
$ mkdir -p ~/.zsh/plugins
$ git clone https://github.com/MenkeTechnologies/zsh-cargo-completion.git \
    ~/.zsh/plugins/zsh-cargo-completion
```

It provides both paths `zshrc` expects: `zsh-cargo-completion.plugin.zsh` at the
root (the `source` target) and `src/_cargo` (the `fpath` entry).

The `~/.zsh/plugins/docker/` entry on the `fpath` line points at nothing — leave
it. Docker Desktop populates `~/.docker/completions`, which is already on the
`fpath`.

### 4.2 Install the shell config

**Copy, don't symlink** — or symlink deliberately, but pick one. These four files
have no `.` prefix in the repo so they show up in a plain `ls`:

```
$ cp ~/dotfiles/zshrc    ~/.zshrc
$ cp ~/dotfiles/zshenv   ~/.zshenv
$ cp ~/dotfiles/zprofile ~/.zprofile
$ cp ~/dotfiles/gitconfig ~/.gitconfig
$ cp ~/dotfiles/p10k.zsh ~/.p10k.zsh
```

⚠️ **Order within this phase:** `zshenv` → `zprofile` → `zshrc` is the order zsh
reads them, and it matters. `zshenv` sources `~/.cargo/env`; `zprofile` then runs
`brew shellenv`, which prepends `/opt/homebrew/bin` *ahead* of `~/.cargo/bin`.
Homebrew therefore wins any name collision with rustup — see LANGUAGES.md § Rust
for why that's a trap worth remembering.

⚠️ If ghcup wrote its own `~/.zshrc` in Phase 2, this `cp` silently overwrites
it. That's the intent, but check you aren't losing a PATH line you wanted.

`p10k.zsh` is 89KB of generated config. Commit it, never hand-edit it — re-run
`p10k configure` instead.

**Verify:** open a fresh terminal. No errors on startup, and:

```
$ exec zsh
$ ll              # eza with icons and a git column
$ echo $EDITOR    # nvim
```

If `ll` reports `Library not loaded: libgit2`, see LANGUAGES.md § Rust — it means
`brew "libgit2"` didn't land.

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

Details and the pnpm/corepack reasoning: **[LANGUAGES.md § Node](LANGUAGES.md#node)**.

**Verify:** `node --version && npm --version && pnpm --version`

---

## Phase 6 — XDG configs

Copy each directory whole. This also brings across the five tmux plugins vendored
under `tmux/plugins/`, so there is no tpm install step.

```
$ mkdir -p ~/.config
$ cp -R ~/dotfiles/nvim  ~/.config/nvim
$ cp -R ~/dotfiles/tmux  ~/.config/tmux
$ cp -R ~/dotfiles/kitty ~/.config/kitty
$ cp -R ~/dotfiles/git   ~/.config/git
```

⚠️ **`cp -R src dst` behaves differently depending on whether `dst` exists.** If
it doesn't, `src` *becomes* `dst`. If it does, `src` is copied *inside* it,
giving you `~/.config/kitty/kitty/kitty.conf`. This bites with kitty
specifically, because kitty creates `~/.config/kitty` the first time it launches
— and you have almost certainly launched it by now. Check the depth:

```
$ ls ~/.config/kitty/kitty.conf      # not ~/.config/kitty/kitty/kitty.conf
```

Flatten with `mv ~/.config/kitty/kitty/* ~/.config/kitty/` if it nested.

`~/.config/git/ignore` is picked up automatically as the global ignore file — no
`core.excludesfile` setting needed.

### 6.1 tmux

```
$ tmux source ~/.config/tmux/tmux.conf
```

**Verify:** start `tmux`, confirm the Catppuccin Mocha status bar and that the
prefix is `Ctrl-Space`, not `Ctrl-b`.

### 6.2 Neovim

⚠️ **Order:** last, after Node (Phase 5) and Go (Phase 3). Eight of the 14 Mason
servers are npm packages. See
**[LANGUAGES.md § Neovim's language servers](LANGUAGES.md#neovims-language-servers)**
for the full dependency table and the `:Lazy restore` vs `:Lazy sync` trap.

```
$ nvim
```

lazy.nvim bootstraps itself and installs the plugin specs, then Mason pulls the
servers. Watch for red entries in `:Mason`.

**Verify:** `:Lazy` (all installed, no errors), `:Mason`, `:checkhealth`

### 6.3 kitty

The config asks for `MesloLGS Nerd Font Mono`, installed by Phase 3
(`font-meslo-lg-nerd-font`). If glyphs render as boxes, that cask didn't land.

---

## Phase 7 — Claude Code

Single profile at `~/.claude`, using the default `CLAUDE_CONFIG_DIR`.

```
$ cp ~/scripts/claude/settings.json ~/.claude/settings.json
$ git clone git@github.com:nandanjp/claude-skills.git ~/.claude/skills
```

Skills live in their own repo, which is why only a `.gitignore` is in the
snapshot.

Plugins: don't copy `installed_plugins.json` — it points at cache directories
that aren't in the snapshot. Reinstall from the marketplace:

```
$ claude plugin marketplace add anthropics/claude-plugins-official
$ claude plugin install gopls-lsp@claude-plugins-official
$ claude plugin install frontend-design@claude-plugins-official
```

Project memory lives at `~/.claude/projects/<slug>/memory/`. The `~/scripts`
snapshot flattens it to `claude/personal/memory/<slug>/`; restore into the nested
shape.

```
$ claude auth login --email nandan.jp17@gmail.com
```

**Verify:** in a session, `/plugin` shows both plugins enabled.

---

## Phase 8 — GUI apps 🖐

Phase 3 installed these; each still needs a manual sign-in or restore.

| App | What's needed |
|---|---|
| **Tailscale** | Sign in, re-authorize this machine in the tailnet |
| **Docker Desktop** | First launch, accept terms, enable shell completions |
| **Anki** | Sync from AnkiWeb |
| **VS Code** | Sign in for Settings Sync; the 12 extensions are already installed |
| **Raycast** | Sign in, re-import custom commands and hotkeys |
| **Termius** | Sign in — SSH hosts live in its own sync, not in this repo |
| **Discord** | Sign in |
| **Zen / Chrome** | Sign in, then import `~/scripts/bookmarks.txt` (46 links, plain text) |

---

## Not in this repo

None of the following is captured here — state it and move on:

- `~/.ssh/*` — keys, regenerated in Phase 1
- `~/.zsh_history` — shell history
- `~/.config/raycast/` — **deliberately excluded.** It contains
  `aster-endpoint.json`, a live auth token for a local extension endpoint.
  Re-generate the token from the extension rather than committing it.
- Raycast custom commands, Termius hosts, VS Code settings not covered by Sync

---

## Deferred work

### LaTeX

Skipped on 2026-09-11, to be set up whenever LaTeX is next needed. `cask
"basictex"` and `vscode "james-yu.latex-workshop"` both sit in
`~/scripts/Brewfile`.

⚠️ The trap: **BasicTeX ships without `latexmk`**, which is exactly what
latex-workshop's default build recipe calls. Installing the cask and the
extension and expecting a working setup fails on the first build.

```
$ sudo tlmgr update --self                      # bundled tlmgr ships outdated
$ sudo tlmgr install latexmk
$ sudo tlmgr install collection-fontsrecommended
```

Then open a new shell so `/Library/TeX/texbin` lands on PATH via
`/etc/paths.d/TeX`. Everything else (`biblatex`, `pgfplots`, …) is a `tlmgr
install` each time a build log complains about a missing `.sty`.

The alternative is `cask "mactex"` — ~5GB instead of ~100MB, but everything is
preinstalled and none of the above is needed.
