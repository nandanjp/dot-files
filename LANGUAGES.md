# Language toolchains

Install these **before `brew bundle`** — the `go`, `cargo`, `uv` and `npm`
entries in the Brewfile all need a toolchain already on PATH. Shell wiring is
already in `zshrc`, `zshenv` and `zprofile`.

Order:

```
Rust → Haskell → brew bundle → Node → re-run brew bundle → Neovim first launch
```

---

## Rust

rustup, **not** `brew install rust`.

```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ source "$HOME/.cargo/env"
```

`clippy`, `rustfmt` and `rust-analyzer` ship with rustup. Crates come from the
Brewfile's `cargo` entries: `eza`, `bat`, `ripgrep`, `cargo-watch`,
`cargo-feature`.

Completions need a manual clone — `zshrc` sources this path:

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

`zshrc` sets `GOPATH="$HOME/go"` and puts `$GOPATH/bin` on PATH. Tools install
from the Brewfile's `go` entries (`air`, `staticcheck`). `gopls` comes from
Mason, not `go install`.

---

## Node

fnm — not nvm, not `brew node`. The `npm "corepack"` line in the Brewfile fails
on a fresh machine; let it fail, then:

```
$ fnm install --lts
$ fnm default lts-latest
$ exec zsh
$ corepack enable
```

Then re-run `brew bundle install`. pnpm comes from corepack, not Homebrew.

---

## Python

No Homebrew python — macOS `/usr/bin/python3` plus `uv`.

```
$ brew install uv
$ uv tool install ruff
```

Per-project work is `uv venv` / `uv sync`. `pyright`, `black` and `isort` come
from Mason.

---

## Haskell

Run non-interactively so the installer doesn't edit your shell files — `zshrc`
already sources `~/.ghcup/env`.

```
$ export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
$ export BOOTSTRAP_HASKELL_INSTALL_HLS=1
$ curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Expect a few hundred MB and ~10 minutes. Verify:

```
$ source ~/.ghcup/env && ghc --version && cabal --version
$ haskell-language-server-wrapper --version
```

---

## Lua

Nothing to install. `lua_ls` and `stylua` come from Mason.

---

## Neovim

Open Neovim **last** — of the 14 servers in `lsp-config.lua`, eight need Node
and one needs Go.

Restore the pinned plugin versions with `:Lazy restore`, never `:Lazy sync`:

```
$ nvim --headless "+Lazy! restore" +qa
```

Then open `nvim` normally and let Mason finish — it won't complete under
`--headless`.
