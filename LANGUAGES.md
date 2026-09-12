# Language toolchains

Every language this machine builds in, how it gets installed, and where its
binaries land. **Run this before `brew bundle`** — the `go`, `cargo`, `uv` and
`npm` entries at the bottom of the Brewfile all need a toolchain already on PATH.

The shell wiring is already in `zshrc`, `zshenv` and `zprofile`; this doc covers
what those files *expect to find*.

| Language | Installed by | Binaries land in | PATH set in |
|---|---|---|---|
| Rust | rustup (**not** Homebrew) | `~/.cargo/bin` | `zshenv` |
| Go | `brew "go"` | `~/go/bin` | `zshrc` |
| Node | fnm | fnm multishell dir | `zshrc` (`fnm env`) |
| Python | system `python3` + `uv` | `~/.local/bin` | `zshrc` |
| Haskell | ghcup | `~/.ghcup/bin` | `~/.ghcup/env`, sourced by `zshrc` |

Install order that works on a blank machine:

```
Rust → Haskell → brew bundle → Node → re-run brew bundle → Neovim first launch
```

Rust and Haskell come first because `brew bundle` has `cargo` entries and
Neovim's Mason list has `hls`. Node comes after the bundle because `fnm` itself
is a Homebrew formula — which is why the bundle gets run twice.

---

## Rust

**rustup, never `brew install rust`.**

```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ source "$HOME/.cargo/env"
```

Current: `rustc 1.98.1`, one toolchain, `stable-aarch64-apple-darwin` (default).

`zshenv` does `. "$HOME/.cargo/env"`, which prepends `~/.cargo/bin` to PATH. Note
that `zshenv` is read *before* `zprofile`, and `zprofile` runs `brew shellenv`,
which prepends `/opt/homebrew/bin`. **Homebrew therefore wins any name collision
with rustup.**

⚠️ That is not theoretical. A `brew "rust"` was installed on this machine and
shadowed rustup completely: `which rustc` resolved to `/opt/homebrew/bin/rustc`,
so `rustup update` upgraded a toolchain that nothing was actually running. It was
removed on 2026-09-12 and the Brewfile now carries an explicit comment saying not
to re-add it. If `which -a rustc` ever prints two paths again, that's the bug.

⚠️ **Removing `brew "rust"` breaks `eza` and `bat`** until you put `libgit2`
back. Homebrew auto-removes dependencies that become orphaned, and `libgit2`
arrived as a transitive dep of rust — but `eza` and `bat` are cargo-built and
link it *dynamically*, so both die with `Library not loaded: libgit2.1.9.dylib`.
Since `ls`/`ll`/`la`/`tree` are all `eza` aliases, the shell looks broken. The
Brewfile now lists `brew "libgit2"` explicitly for exactly this reason.

### Rust tooling

`rustup` ships `clippy`, `rustfmt` and `rust-analyzer` in `~/.cargo/bin` — no
separate install. Neovim's Mason also installs its own `rust_analyzer`; that's
the copy Neovim uses.

Crates from the Brewfile (`cargo install`, into `~/.cargo/bin`):

| Crate | Why it's load-bearing |
|---|---|
| `eza` | the `ls` / `ll` / `la` / `tree` aliases (`zshrc:60-67`) |
| `bat` | the `inv` alias's fzf preview (`zshrc:73`) |
| `ripgrep` | telescope.nvim's `live_grep` |
| `cargo-watch` | the `cargow` alias (`zshrc:72`) |
| `cargo-feature` | convenience only |

The first four are why a broken Rust install is immediately visible in the shell.

Completions come from `zsh-cargo-completion`, which is **not** a Homebrew formula
and has to be cloned by hand — `zshrc` `source`s it, and a missing `source`
target errors on every shell start (a missing `fpath` entry is silently ignored):

```
$ mkdir -p ~/.zsh/plugins
$ git clone https://github.com/MenkeTechnologies/zsh-cargo-completion.git \
    ~/.zsh/plugins/zsh-cargo-completion
```

---

## Go

```
$ brew install go
```

Current: `go1.27.1 darwin/arm64`. `zshrc` sets `GOPATH="$HOME/go"` and puts
`$GOPATH/bin` on PATH; `go install` targets it with no further config.

Tools (in the Brewfile as `go "..."` entries):

- `github.com/air-verse/air` — live reload for the Go services
- `honnef.co/go/tools/cmd/staticcheck` — the diagnostics source wired up at
  `nvim/lua/plugins/none-ls.lua:11`

`gopls` is deliberately **not** a `go install` entry — Mason installs and manages
its own copy for Neovim. Installing both leaves two versions drifting apart.

Formatting is `goimports` + `gofmt` via none-ls, which ship with the toolchain.

---

## Node

fnm, not nvm and not a Homebrew `node`. The formula is in the Brewfile; the
runtime is not, so it's a two-step install.

```
$ fnm install --lts
$ fnm default lts-latest
$ exec zsh
$ corepack enable
```

Current: `v24.21.0`, aliased both `default` and `lts-latest`.

⚠️ **`npm "corepack"` in the Brewfile fails on a fresh machine.** There is no npm
until fnm has installed a Node, and fnm is itself installed *by* that bundle run.
Let the line fail, do the four commands above, then re-run `brew bundle install`.

`eval "$(fnm env)"` in `zshrc` is what puts the active version's bin dir on PATH
— it resolves through `~/.local/state/fnm_multishells/<pid>_<ts>/bin`, so the
path is per-shell and changes between sessions. That's normal.

### Package managers

pnpm is **not** installed as a formula. `corepack` provides the shim and reads
each project's `packageManager` field, so every repo pins its own version. A
`brew "pnpm"` would shadow that shim on PATH — it was dropped for this reason.

`zshrc` exports `PNPM_HOME="$HOME/Library/pnpm"` and prepends it, guarded so
repeated sourcing doesn't duplicate the entry.

---

## Python

There is no Homebrew python. The interpreter is macOS's `/usr/bin/python3`, and
`zshrc` has `alias python=python3`. Everything project-level goes through `uv`.

```
$ brew install uv
$ uv tool install ruff
```

`uv tool install` puts shims in `~/.local/bin`, which `zshrc` *prepends* to PATH
— ahead of Homebrew, unlike every other entry.

- `ruff` — installed as a standalone uv tool; also in Neovim's Mason list, which
  keeps its own copy for the LSP
- `pyright` — Mason only, not installed system-wide
- `black` + `isort` — referenced by `none-ls.lua`; Mason supplies them

Per-project work is `uv venv` / `uv sync`, never `pip install` into the system
interpreter.

---

## Haskell

ghcup. Confirmed in scope because Neovim's Mason list includes `hls`.

⚠️ **Do not let the installer touch your shell config.** `zshrc` already sources
`~/.ghcup/env` behind a `[ -f ... ]` guard, so ghcup only needs to create that
file. The bootstrap script only edits shell files when
`BOOTSTRAP_HASKELL_ADJUST_BASHRC=1`, so running non-interactively avoids the
question — and avoids it writing a `~/.zshrc` that would then block installing
this repo's own.

```
$ export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
$ export BOOTSTRAP_HASKELL_INSTALL_HLS=1
$ curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Current: GHC `9.10.3` (recommended, hls-powered), cabal `3.16.1.0`,
stack `3.11.1`, HLS `2.14.0.0`.

Expect a few hundred MB and ~10 minutes.

**Verify:**

```
$ ls ~/.ghcup/env                        # zshrc keys off this file existing
$ source ~/.ghcup/env && ghc --version && cabal --version
$ haskell-language-server-wrapper --version
```

HLS ships one binary per GHC version and the `-wrapper` picks the right one from
the project. Mason has its own copies under `~/.local/share/nvim/mason/bin` for
GHC 9.6 / 9.8 / 9.10 / 9.12 / 9.14 — only the 9.10.3 one matches the installed
compiler, which is fine; the wrapper handles the selection.

---

## Lua

No system toolchain. `lua_ls` comes from Mason and exists to edit this repo's own
Neovim config. `.luarc.json` in `nvim/` is what stops it complaining about the
`vim` global. Formatting is `stylua` via none-ls, also Mason-supplied.

---

## Neovim's language servers

`nvim/lua/plugins/lsp-config.lua` has a 14-server `ensure_installed` list. Mason
downloads all of them itself, but they are not all self-contained:

| Needs | Servers |
|---|---|
| Node | `ts_ls`, `jsonls`, `tailwindcss`, `html`, `emmet_language_server`, `yamlls`, `dockerls`, `pyright` |
| Go | `gopls` |
| ghcup | `hls` |
| nothing | `lua_ls`, `rust_analyzer`, `ruff`, `terraformls` |

So **open Neovim last**, after Node and Go exist, or eight of them fail on first
launch and you have to re-run `:MasonInstall`.

⚠️ `terraformls` is in the list but there is no `terraform` binary on this
machine — the LSP installs and runs fine, it just has no CLI to pair with. Drop
`"terraformls"` from `lsp-config.lua:16` if you want a clean `:Mason` list.

⚠️ **Use `:Lazy restore`, never `:Lazy sync`, on a fresh machine.** `sync` moves
every plugin to its latest commit and rewrites `lazy-lock.json`, discarding the
pinned versions. `restore` checks out exactly what the lockfile records, which is
the entire reason the lockfile is committed.

This has bitten before: `sync` moved `nvim-treesitter` from `master` to `main`, a
breaking rewrite that dropped the `configs` module, and `treesitter.lua:5` died
with `module 'nvim-treesitter.configs' not found`.

```
$ nvim --headless "+Lazy! restore" +qa      # correct on a rebuild
```

Mason's `ensure_installed` runs asynchronously and will not finish under
`--headless`, which exits first. Open `nvim` normally and wait, or drive
`:MasonInstall` explicitly.

⚠️ `nvim-treesitter`'s `master` branch is archived upstream. The pinned commit
works today, but a future update means migrating `treesitter.lua` to the `main`
branch API. Do that deliberately, not by accident during a rebuild.
