# Laptop rebuild — manual steps

Restores this machine from the `~/scripts` snapshot taken 2026-09-10.

Work top to bottom. The order matters in four places, each flagged with **Order**.
Every phase ends with a *Verify* command — don't move on until it passes.

Legend: `$` = run in terminal · 🖐 = manual/GUI step · ⚠️ = known trap

---

## Phase 0 — Already done

Verified on 2026-09-11, nothing to do:

- Xcode Command Line Tools → `/Library/Developer/CommandLineTools`
- Homebrew 6.0.22 at `/opt/homebrew`, with `~/.zprofile` running `brew shellenv`
- Casks already present: `claude-code`, `google-chrome`, `rectangle`, `zen`
- `~/projects` restored (spending, rust, divedeep, personal-api, nandanjp, tablecn)

---

## Phase 1 — Git identity and SSH

**Order:** first. Three later phases clone over `git@github.com:`, and they all fail
without a key on GitHub.

### 1.1 Git identity

One identity everywhere — no per-directory overrides.

```
$ git config --global user.name "Nandan Patel"
$ git config --global user.email "nandan.jp17@gmail.com"
$ git config --global init.defaultBranch main
$ git config --global pull.rebase true
```

### 1.2 SSH key

```
$ ssh-keygen -t ed25519 -C "nandan.jp17@gmail.com"
$ eval "$(ssh-agent -s)"
```

Create `~/.ssh/config` so the key loads from Keychain on every boot:

```
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

```
$ ssh-add --apple-use-keychain ~/.ssh/id_ed25519
$ pbcopy < ~/.ssh/id_ed25519.pub
```

🖐 Paste into **github.com → Settings → SSH and GPG keys → New SSH key**.

**Verify:**

```
$ ssh -T git@github.com          # "Hi nandanjp! You've successfully authenticated"
$ git -C ~/projects/web-apps/divedeep fetch
```

---

## Phase 2 — Rust toolchain

⚠️ **Order:** before `brew bundle`. The Brewfile has ten `cargo "..."` entries
(`bat`, `eza`, `ripgrep`, `cargo-watch`, `sqlx-cli`, …) but **no `rust` or `rustup`
formula** — rustup was installed out-of-band on the old machine. Run `brew bundle`
first and all ten cargo lines fail.

```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ source "$HOME/.cargo/env"
```

**Verify:** `cargo --version`

### Haskell / ghcup

Confirmed in scope — it backs the `hls` entry in Neovim's Mason list. Installs GHC,
cabal, stack and HLS under `~/.ghcup`. Expect a few hundred MB and ~10 minutes.

⚠️ **Do not let the installer touch your shell config.** `zshrc:26` already sources
`~/.ghcup/env` behind a `[ -f ... ]` guard, so ghcup only needs to create that file.
If the installer writes its own `~/.zshrc`, that file will block the `ln -s` in
Phase 4.3. Running non-interactively avoids the question entirely — the bootstrap
script only edits shell files when `BOOTSTRAP_HASKELL_ADJUST_BASHRC=1`, which we
deliberately leave unset:

```
$ export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
$ export BOOTSTRAP_HASKELL_INSTALL_HLS=1
$ curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

If you'd rather run it interactively, answer **no** to "add to PATH / adjust shell
config" and **yes** to installing HLS.

**Verify:**

```
$ ls ~/.ghcup/env                 # must exist — zshrc:26 keys off this
$ ls ~/.zshrc                     # must NOT exist yet — Phase 4.3 creates it
$ source ~/.ghcup/env && ghc --version && cabal --version
$ haskell-language-server-wrapper --version
```

---

## Phase 3 — Homebrew bundle

15 formulae, 13 casks, 12 VS Code extensions, 5 Go tools, 5 cargo crates, 1 uv, 1 npm.

Every list was trimmed on 2026-09-11 against what the configs and `~/projects`
actually use. Everything dropped sits commented out in the Brewfile with its reason,
so the old machine's state is still on record.

| List | Was | Now | Basis for the cut |
|---|---|---|---|
| casks | 20 | 13 | dropped what wasn't wanted on a fresh machine |
| formulae | 27 | 15 | dropped everything with no consumer in the tree |
| VS Code ext | 29 | 12 | **Neovim is the primary editor** — its 15 Mason LSPs already cover Go, Rust, Python, Haskell, so VS Code keeps only what Neovim doesn't do |
| cargo crates | 10 | 5 | kept the 4 the configs depend on, plus `cargo-feature` |

The 4 load-bearing crates are worth knowing by name, since the shell visibly breaks
without them: `eza` (the `ls`/`ll`/`la`/`tree` aliases), `bat` (the `inv` preview),
`cargo-watch` (the `cargow` alias) and `ripgrep` (telescope's `live_grep`).

**All 13 casks are already installed**, so this run touches no casks and prompts for
no passwords. What's left is 15 formulae plus the language-tool entries.

Two consequences of the formula trim to keep in mind:

- ⚠️ **`cmake` and `pkgconf` were dropped.** Neither had a direct consumer, but both
  are common build dependencies for native cargo crates. If any of the 10 cargo
  entries fails to compile — `sccache` and `sqlx-cli` are the likely candidates —
  reinstate those two first before debugging anything else.
- **`llvm` was dropped**, and `zshrc` lines 11–12 and 18 went with it. Those set
  `LDFLAGS`/`CPPFLAGS`/`PATH` against the llvm prefix as a Rust build optimization
  that is no longer wanted. Leaving them behind would have pointed build flags at a
  prefix that no longer exists.

⚠️ If you ever re-add a cask, add it to the Brewfile too. `brew bundle` is
declarative in one direction only: it installs what's listed, but never removes what
isn't, so the file silently drifts out of date otherwise.

```
$ cd ~/scripts
$ brew bundle install --file=Brewfile
```

⚠️ **Expected failure: `npm "corepack"`.** There is no `npm` on this machine yet —
Node arrives via `fnm` in Phase 6. Let this one fail; Phase 6 fixes it. Nothing else
in the Brewfile depends on it.

⚠️ `prometheus` is declared `restart_service: :changed`, so brew starts it as a
background service. If you don't want a metrics server running at login:

```
$ brew services stop prometheus
```

**Verify:**

```
$ brew bundle check --file=Brewfile --verbose
```

Everything except the corepack line should come back satisfied.

---

## Phase 4 — Shell

### 4.1 Missing zsh plugin

⚠️ `zshrc:32` sources `zsh-cargo-completion`, which was **not** captured in the
snapshot. Unlike a missing `fpath` entry (harmless — zsh ignores those), a missing
`source` target prints an error on every single shell start.

```
$ mkdir -p ~/.zsh/plugins
$ git clone https://github.com/MenkeTechnologies/zsh-cargo-completion.git \
    ~/.zsh/plugins/zsh-cargo-completion
```

✅ Verified 2026-09-11 — this is the right repo. It provides both paths the zshrc
expects: `zsh-cargo-completion.plugin.zsh` at the root (the `source` target) and
`src/_cargo` (the `fpath` entry).

The `~/.zsh/plugins/docker/` entry on the `fpath` line is a path that doesn't exist
— leave it, zsh silently ignores missing `fpath` entries, and Docker Desktop
populates `~/.docker/completions` (already on the `fpath`) anyway. Only a missing
`source` target is fatal.

### 4.2 Drop the Claude profile wrappers

The snapshot's `zshrc` carries a two-account setup that this rebuild no longer uses.
Delete the block from the comment `# Claude Code account switching` through the
closing brace of `claude-personal()` — that's `_claude_ensure_login()`,
`claude-ridge()` and `claude-personal()`.

Do this before linking, so the file is clean the first time the shell reads it. With
the block gone you just run `claude`, and the Keychain holds the one credential it
needs. Phase 7 assumes this edit is done.

✅ Done 2026-09-11 — it was lines 74–92 by then, not 79–96, because removing the
llvm exports in Phase 3 shifted everything up by three. `zshrc` went 103 → 78 lines
and still passes `zsh -n`.

### 4.3 Install the shell config

**Copy, don't symlink.** `~/scripts` is a temporary staging area to be deleted once
the rebuild is done (see Phase 9), so nothing in `$HOME` may point into it.

```
$ cp ~/scripts/zshrc ~/.zshrc
```

The trade-off: edits to `~/.zshrc` no longer flow back, so `~/scripts` goes stale the
moment you tweak anything. That's fine here — the durable copy will be a fresh
dotfiles repo built from the live `~/.config` at the end, not this snapshot.

### 4.4 Prompt theme

⚠️ `~/.p10k.zsh` was **not** captured — your prompt styling is genuinely lost and
has to be rebuilt by hand. `zshrc:99` guards the source, so the shell works
meanwhile with the default p10k prompt.

```
$ exec zsh
$ p10k configure
```

**Verify:** open a fresh terminal. No errors on startup, and:

```
$ ll              # eza with icons and git column
$ echo $EDITOR    # nvim
```

---

## Phase 5 — XDG configs

Copy each directory whole, for the same reason as 4.3 — nothing in `$HOME` may point
into `~/scripts`. Copying the directories entire also brings across the five tmux
plugins already vendored under `config/tmux/plugins/`, so there's no tpm install step.

```
$ mkdir -p ~/.config
$ cp -R ~/scripts/config/nvim  ~/.config/nvim
$ cp -R ~/scripts/config/tmux  ~/.config/tmux
$ cp -R ~/scripts/config/kitty ~/.config/kitty
$ cp -R ~/scripts/config/git   ~/.config/git
```

⚠️ **`cp -R src dst` behaves differently depending on whether `dst` already exists.**
If it doesn't, `src` *becomes* `dst`. If it does, `src` is copied *inside* it, giving
you `~/.config/kitty/kitty/kitty.conf`. This bites with kitty specifically, because
kitty creates `~/.config/kitty` the first time it launches — and Phase 4.4 tells you
to open kitty to run `p10k configure`. Check the depth afterwards:

```
$ ls ~/.config/kitty/kitty.conf      # not ~/.config/kitty/kitty/kitty.conf
```

If it did nest, flatten it with `mv ~/.config/kitty/kitty/* ~/.config/kitty/` and
`rmdir ~/.config/kitty/kitty`.

`~/.config/git/ignore` is picked up automatically as the global ignore file — no
`core.excludesfile` setting needed.

### 5.1 tmux

tpm and all plugins are already vendored, so there's no `prefix + I` install step.

```
$ tmux source ~/.config/tmux/tmux.conf
```

**Verify:** start `tmux`, confirm the Catppuccin Mocha status bar, and that the
prefix is `Ctrl-Space` (not `Ctrl-b`).

### 5.2 Neovim

⚠️ **Order:** after Phase 6 if you want a clean first run. Mason's `ensure_installed`
list is 15 servers, and 8 of them (`ts_ls`, `jsonls`, `tailwindcss`, `html`,
`emmet_language_server`, `yamlls`, `dockerls`, `pyright`) are npm packages that need
Node. `gopls` needs Go (Phase 3 ✓), `hls` needs ghcup (Phase 2 ✓).

⚠️ `zls` is still in that list even though `brew "zig"` and `brew "zls"` were dropped
in the trim. Mason downloads its own copy, so it will install fine — it's just a Zig
language server with no Zig compiler to pair with. Harmless; remove `"zls"` from
`lua/plugins/lsp-config.lua:16` if you want a clean `:Mason` list.

```
$ nvim
```

lazy.nvim bootstraps itself and installs the 11 plugin specs, then Mason pulls the
servers. Watch for red entries in `:Mason`.

⚠️ **Use `:Lazy restore`, never `:Lazy sync`, on a fresh machine.** `sync` updates
every plugin to its latest commit and *rewrites* `lazy-lock.json`, throwing away the
versions the old machine was pinned to. `restore` checks out exactly what the
lockfile records — which is the entire point of having copied it across.

This isn't hypothetical: running `sync` here moved `nvim-treesitter` from the
`master` branch to `main`, which is a breaking rewrite that dropped the `configs`
module, and `treesitter.lua:5` died with `module 'nvim-treesitter.configs' not
found`. Recovery was to restore `lazy-lock.json` from the snapshot and re-run
`:Lazy! restore`. Headless equivalents:

```
$ nvim --headless "+Lazy! restore" +qa      # correct on a rebuild
$ nvim --headless "+Lazy! sync"    +qa      # updates + rewrites the lockfile
```

⚠️ **`nvim-treesitter`'s `master` branch is archived upstream.** The pinned commit
works today, but a future update means migrating `treesitter.lua` to the `main`
branch API. Do that deliberately, not by accident during a rebuild.

Mason's `ensure_installed` runs asynchronously and won't finish under
`nvim --headless`, which exits first. Either open `nvim` normally and wait, or drive
it explicitly:

```
$ nvim --headless "+MasonInstall lua-language-server gopls rust-analyzer ..." +qa
```

**Verify:**

```
:Lazy       # all plugins installed, no errors
:Mason      # servers installed; anything missing is a Node/Go gap
:checkhealth
```

### 5.3 kitty

The config wants `MesloLGS Nerd Font Mono`, installed by Phase 3
(`font-meslo-lg-nerd-font`). Launch kitty — if glyphs are boxes, that cask didn't land.

---

## Phase 6 — Node

```
$ fnm install --lts
$ fnm default lts-latest
$ exec zsh
$ corepack enable
```

Then retry the entry that failed in Phase 3:

```
$ cd ~/scripts && brew bundle install --file=Brewfile
```

**Verify:** `node --version && npm --version && pnpm --version`

Go back and finish **5.2** now if you deferred it.

---

## Phase 7 — Claude Code

Single profile at `~/.claude`, using the default `CLAUDE_CONFIG_DIR`. The snapshot's
`claude/personal/` and `claude/ridge/` directories are superseded — ignore them.

### 7.1 Settings

Use the top-level snapshot config. It's the fuller one: model `claude-sonnet-5`,
both plugins enabled, dark theme. (`claude/personal/settings.json` carried only the
theme; `claude/ridge/settings.json` was byte-identical to this file.)

```
$ cp ~/scripts/claude/settings.json ~/.claude/settings.json
```

⚠️ This overwrites the `~/.claude/settings.json` this machine created on first run.
That file currently holds only `{"theme":"dark"}`, so nothing of yours is lost.

### 7.2 Skills

Its own repo, which is why only a `.gitignore` shipped in the snapshot:

```
$ git clone git@github.com:nandanjp/claude-skills.git ~/.claude/skills
```

### 7.3 Plugins

Don't copy `installed_plugins.json` — it points at cache directories that aren't in
the snapshot. Reinstall from the marketplace instead:

```
$ claude plugin marketplace add anthropics/claude-plugins-official
$ claude plugin install gopls-lsp@claude-plugins-official
$ claude plugin install frontend-design@claude-plugins-official
```

### 7.4 Project memory

Live layout on this machine is `~/.claude/projects/<slug>/memory/`, while the
snapshot flattened it to `claude/personal/memory/<slug>/`. Restore into the nested
shape — the `personal/` path is just where the old split happened to file it, and
these memories aren't account-specific:

```
$ mkdir -p ~/.claude/projects/-Users-nandanpatel-projects-misc-spending
$ mkdir -p ~/.claude/projects/-Users-nandanpatel-projects-programming-rust
$ cp -R ~/scripts/claude/personal/memory/-Users-nandanpatel-projects-misc-spending \
       ~/.claude/projects/-Users-nandanpatel-projects-misc-spending/memory
$ cp -R ~/scripts/claude/personal/memory/-Users-nandanpatel-projects-programming-rust \
       ~/.claude/projects/-Users-nandanpatel-projects-programming-rust/memory
```

That's 4 memories for the spending CLI and 2 for the Rust `parsley` project.

### 7.5 Log in

```
$ claude auth login --email nandan.jp17@gmail.com
```

**Verify:** inside a session, `/skills` lists 11 skills and `/plugin` shows both
plugins enabled.

---

## Phase 8 — GUI apps 🖐

Phase 3 installed these; each still needs a manual sign-in or restore.

All 13 casks are installed. Each still needs a manual sign-in or restore.

| App | What's needed |
|---|---|
| **Tailscale** | Sign in, re-authorize this machine in the tailnet |
| **Docker Desktop** | First launch, accept terms, enable the shell completions |
| **Anki** | Sync from AnkiWeb (the WaniKani/Japanese decks in `bookmarks.txt`) |
| **VS Code** | Sign in for Settings Sync; the 28 extensions are already installed |
| **Raycast** | Sign in, re-import your custom commands and hotkeys |
| **Termius** | Sign in — SSH hosts are stored in its own sync, not in this snapshot |
| **Discord** | Sign in |
| **Zen / Chrome** | Sign in, then import `~/scripts/bookmarks.txt` (47 links, plain text — paste them in by hand or via the bookmark manager) |

⚠️ `config/raycast/aster-endpoint.json` holds a **live auth token** for a local
Raycast extension endpoint on port 7265. Don't restore it blindly — re-generate the
token from the extension itself, and see Phase 9 before committing this folder.

---

## Phase 9 — Cleanup

### 9.1 Retire `~/dot-files`

It's the old repo (`github.com/nandanjp/dot-files`, last commit May 2026) and every
file in it is older than its `~/scripts/config` counterpart — nvim's `lazy-lock.json`,
four plugin specs, `tmux.conf`, `kitty.conf`, and a `.zshrc` still on `nvm` rather
than `fnm`. Leaving it in place recreates the two-sources-of-truth problem.

```
$ git -C ~/dot-files status        # confirm nothing uncommitted but .DS_Store
$ rm -rf ~/dot-files               # the repo still exists on GitHub
```

### 9.2 Retire `~/scripts` and build a real dotfiles repo

`~/scripts` is staging, not a home. Everything was **copied** out of it rather than
symlinked (Phases 4.3 and 5), so once the rebuild is verified nothing depends on it:

```
$ find ~ -maxdepth 2 -type l -lname '*scripts*'    # must print nothing
$ rm -rf ~/scripts
```

Then build the durable repo from the **live** configs rather than from this snapshot
— that way it records what you actually ended up using, not what the old machine had:

```
$ mkdir ~/dotfiles && cd ~/dotfiles && git init
$ cp -R ~/.config/{nvim,tmux,kitty,git} .
$ cp ~/.zshrc ~/.p10k.zsh .
$ cp ~/scripts/Brewfile .        # do this BEFORE deleting ~/scripts
```

⚠️ Two things to keep out of git history permanently:

- `config/raycast/aster-endpoint.json` — a live auth token. Regenerate it from the
  Raycast extension rather than carrying it over.
- `~/.p10k.zsh` is 89KB of generated config. Fine to commit, just don't hand-edit it.

```
$ printf '.DS_Store\nraycast/aster-endpoint.json\ntmux/plugins/*/.git\n' > .gitignore
$ git add -A && git status       # confirm no tokens staged
$ git commit -m "Dotfiles from the 2026-09-11 rebuild"
```

Then create a private `nandanjp/dotfiles` repo on GitHub and push. This also
supersedes `~/dot-files` from 9.1 — one repo, built from a machine that works.

---

## Deferred work

### LaTeX

Deliberately skipped on 2026-09-11 — to be set up whenever LaTeX is next needed.
Both `cask "basictex"` and `vscode "james-yu.latex-workshop"` are commented out in
the Brewfile.

⚠️ The trap to know about before re-enabling: **BasicTeX ships without `latexmk`**,
which is exactly what latex-workshop's default build recipe calls. Installing the
cask and the extension and expecting a working setup will fail on the first build.
Nothing in the original snapshot documented this — the old machine's setup steps
were never captured, only the two Brewfile lines.

Bringing it back means:

```
$ # uncomment both lines in ~/scripts/Brewfile, then:
$ brew bundle install --file=~/scripts/Brewfile
$ sudo tlmgr update --self                      # bundled tlmgr ships outdated
$ sudo tlmgr install latexmk
$ sudo tlmgr install collection-fontsrecommended
```

Then open a new shell so `/Library/TeX/texbin` lands on `PATH` via
`/etc/paths.d/TeX`. Everything else (`biblatex`, `pgfplots`, …) is a `tlmgr install`
each time a build log complains about a missing `.sty`.

The alternative is `cask "mactex"` — ~5GB instead of ~100MB, but everything is
preinstalled and none of the above is needed.

---

## Not recoverable from this snapshot

State the following and move on — none of it was captured:

- `~/.p10k.zsh` — prompt theme, rebuild with `p10k configure` (Phase 4.4)
- `~/.ssh/*` — keys, regenerated in Phase 1
- `~/.zsh_history` — shell history
- Raycast custom commands, Termius hosts, VS Code settings not covered by Sync
- `config/ghc/ghci_history` is present but it's only 100 lines of REPL scratch —
  no reason to restore it
