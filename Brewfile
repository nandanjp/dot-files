# Brewfile — the live state of this machine.
#
#   $ brew bundle install --file=~/dotfiles/Brewfile
#   $ brew bundle check   --file=~/dotfiles/Brewfile --verbose
#
# This file is declarative in one direction only: `brew bundle` installs what is
# listed but never removes what isn't. If you `brew install` something and want
# to keep it, add it here in the same breath or the file silently drifts.
#
# Ordering note: the `cargo`, `go`, `uv` and `npm` entries at the bottom need
# their toolchains on PATH first. See LANGUAGES.md — run that before this file.

# --- Formulae -------------------------------------------------------------
# Load/unload environment variables based on $PWD          [zshrc:25]
brew "direnv"
# Fast and simple Node.js version manager                  [zshrc:24]
brew "fnm"
# Command-line fuzzy finder written in Go                  [zshrc:47, :73]
brew "fzf"
# Distributed revision control system
brew "git"
# Open source programming language to build simple/reliable/efficient software
brew "go"
# Portable C library for Git                               [eza + bat link it]
brew "libgit2"
# Run a Kubernetes cluster locally
brew "minikube"
# Ambitious Vim-fork focused on extensibility and agility
brew "neovim"
# Theme for zsh                                            [zshrc:30]
brew "powerlevel10k"
# Easiest, most secure way to use WireGuard and 2FA        [CLI for the cask]
brew "tailscale"
# Define your dev environment as code. For microservice apps on Kubernetes
brew "tilt"
# Terminal multiplexer
brew "tmux"
# Extremely fast Python package installer and resolver, written in Rust
brew "uv"
# Blazing fast terminal file manager written in Rust, based on async I/O
brew "yazi"
# Fish-like fast/unobtrusive autosuggestions for zsh       [zshrc:28]
brew "zsh-autosuggestions"
# Fish shell like syntax highlighting for zsh              [zshrc:79]
brew "zsh-syntax-highlighting"

# There is deliberately no `brew "rust"` here. Rust comes from rustup so that
# `rustup update` controls the compiler; a Homebrew rust shadows ~/.cargo/bin on
# PATH and splits the toolchain in two. See LANGUAGES.md § Rust.
#
# `libgit2` is listed explicitly even though nothing here depends on it: the
# cargo-built `eza` and `bat` link it dynamically. It arrived as a transitive
# dep of `brew "rust"`, and removing rust took it — and both binaries — down
# with it. Keep the line.

# --- Casks ----------------------------------------------------------------
# Memory training application
cask "anki"
# Application uninstaller
cask "appcleaner"
# Terminal-based AI coding assistant
cask "claude-code"
# Voice and text chat software
cask "discord"
# App to build and share containerised applications and microservices
cask "docker-desktop"
# Nerd Font the kitty config asks for by name
cask "font-meslo-lg-nerd-font"
# Web browser
cask "google-chrome"
# GPU-based terminal emulator
cask "kitty"
# Control your tools with a few keystrokes
cask "raycast"
# Move and resize windows using keyboard shortcuts or snap areas
cask "rectangle"
# Mesh VPN based on WireGuard
cask "tailscale-app"
# SSH client
cask "termius"
# Open-source code editor
cask "visual-studio-code"
# Gecko based web browser
cask "zen"

# Casks that were on the pre-2026-09 machine but deliberately not reinstalled
# here live in ~/scripts/Brewfile, which is kept as the full historical record.

# --- VS Code --------------------------------------------------------------
# VS Code is the secondary editor. Neovim is primary and Mason already runs 14
# language servers, so the language extensions are deliberately not duplicated.
vscode "anthropic.claude-code"
vscode "bradlc.vscode-tailwindcss"
vscode "dbaeumer.vscode-eslint"
vscode "docker.docker"
vscode "eamodio.gitlens"
vscode "esbenp.prettier-vscode"
vscode "mechatroner.rainbow-csv"
vscode "mvllow.rose-pine"             # matches the Neovim colorscheme
vscode "pkief.material-icon-theme"
vscode "tamasfe.even-better-toml"
vscode "unifiedjs.vscode-mdx"
vscode "usernamehw.errorlens"

# --- Language tools -------------------------------------------------------
# Each group needs its toolchain installed first — see LANGUAGES.md.

# Go — needs `brew "go"` above. Installs into $GOPATH/bin (~/go/bin).
go "github.com/air-verse/air"              # live reload for the Go services
go "honnef.co/go/tools/cmd/staticcheck"    # nvim none-ls.lua:11 diagnostics source

# Rust — needs rustup, NOT brew. Installs into ~/.cargo/bin.
cargo "bat"                  # zshrc:73 — fzf preview in the `inv` alias
cargo "cargo-feature"
cargo "cargo-watch"          # zshrc:72 — the `cargow` alias
cargo "eza"                  # zshrc:60-67 — ls / ll / la / tree aliases
cargo "ripgrep"              # telescope.nvim live_grep depends on it

# Python — needs `brew "uv"` above. Installs into ~/.local/bin.
uv "ruff"

# Node — needs fnm + a installed Node. This one FAILS on a fresh machine if you
# run `brew bundle` before LANGUAGES.md § Node. Re-run bundle afterwards.
npm "corepack"
