# Load/unload environment variables based on $PWD          [zshrc:28]
brew "direnv"
# Fast and simple Node.js version manager                  [zshrc:27]
brew "fnm"
# Command-line fuzzy finder written in Go                   [zshrc:50, :76]
brew "fzf"
# Distributed revision control system
brew "git"
# Open source programming language to build simple/reliable/efficient software
brew "go"
# Run a Kubernetes cluster locally
brew "minikube"
# Ambitious Vim-fork focused on extensibility and agility
brew "neovim"
# brew "pnpm"   # dropped 2026-09-11 — corepack (bundled with Node 24) provides a
#               # pnpm shim that shadows this on PATH, and reads the packageManager
#               # field so each project gets its own pinned version
# Theme for zsh                                             [zshrc:33]
brew "powerlevel10k"
# Define your dev environment as code. For microservice apps on Kubernetes
brew "tilt"
# Terminal multiplexer
brew "tmux"
# Extremely fast Python package installer and resolver, written in Rust
brew "uv"
# Blazing fast terminal file manager written in Rust, based on async I/O
brew "yazi"
# Fish-like fast/unobtrusive autosuggestions for zsh        [zshrc:31]
brew "zsh-autosuggestions"
# Fish shell like syntax highlighting for zsh               [zshrc:102]
brew "zsh-syntax-highlighting"

# --- Not installed on the 2026-09-11 rebuild -------------------------------
# Present on the old machine; kept as a record. Uncomment to bring back.
#
# No consumer found anywhere in ~/projects:
# brew "helm"                # no Chart.yaml — dramalist uses kustomize
# brew "protobuf"            # no .proto files; go.mod lists it only as indirect
# brew "golang-migrate"      # no migrations dir or go.mod reference
# brew "prometheus", restart_service: :changed
#                            # dramalist runs Prometheus in-cluster via
#                            # k8s/22-prometheus.yaml — a local one is redundant,
#                            # and this entry auto-starts a login service
# brew "glfw"                # OpenGL windowing; no consumer
# brew "freetype"            # font rendering lib; no consumer
#
# Dropped as no longer needed:
# brew "llvm"                # backed LDFLAGS/CPPFLAGS in zshrc:11-12,18 as a Rust
#                            # build optimization; those lines removed 2026-09-11
# brew "zig"                 # no build.zig in the tree
# brew "zls"                 # Zig LSP — goes with zig
# brew "cmake"               # build dep with no direct consumer
# brew "pkgconf"             # build dep with no direct consumer
# brew "shellcheck"          # only brew_upgrade.sh to lint
#
# tap "oven-sh/bun", trusted: true
#                            # orphaned — nothing in this Brewfile came from it
# ---------------------------------------------------------------------------
# Memory training application
cask "anki"
# Terminal-based AI coding assistant
cask "claude-code"
# Voice and text chat software
cask "discord"
# App to build and share containerised applications and microservices
cask "docker-desktop"
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

# --- Not installed on the 2026-09-11 rebuild -------------------------------
# Present on the old machine; kept here as a record. Uncomment to bring back.
#
# Deferred until LaTeX is actually needed again. Note that BasicTeX ships
# without latexmk, which the latex-workshop extension's default build recipe
# requires — see "Deferred work" in REBUILD.md before uncommenting either.
# cask "basictex"                                    # + vscode latex-workshop
#
# Dropped as unneeded on a fresh machine:
# cask "daisydisk"          # paid disk visualiser
# cask "elmedia-player"     # media player; QuickTime/VLC overlap
# cask "font-hack-nerd-font"# second Nerd Font; no config references it
# cask "obsidian"           # notes
# cask "sf-symbols"         # Apple symbol browser
# cask "tg-pro"             # paid, needs licence key
# ---------------------------------------------------------------------------
# VS Code is the secondary editor — Neovim is primary and already runs 15 LSPs,
# so the language servers below were deliberately not duplicated here.
vscode "anthropic.claude-code"
vscode "bradlc.vscode-tailwindcss"    # tablecn + dramalist web/web-admin
vscode "dbaeumer.vscode-eslint"
vscode "docker.docker"
vscode "eamodio.gitlens"
vscode "esbenp.prettier-vscode"
vscode "mechatroner.rainbow-csv"      # misc/spending data files
vscode "mvllow.rose-pine"             # matches the Neovim colorscheme
vscode "pkief.material-icon-theme"
vscode "tamasfe.even-better-toml"
vscode "unifiedjs.vscode-mdx"         # nandanjp blog content
vscode "usernamehw.errorlens"

# Trimmed 2026-09-11. Uncomment to bring back.
#
# Language support Neovim already provides via Mason:
# vscode "golang.go"
# vscode "rust-lang.rust-analyzer"
# vscode "ms-python.python"           # also pulled debugpy + vscode-python-envs
# vscode "ms-python.vscode-pylance"
# vscode "charliermarsh.ruff"
# vscode "haskell.haskell"            # also pulled haskell.language-haskell
#
# No consumer found in ~/projects:
# vscode "ziglang.vscode-zig"         # no .zig files; brew "zig" also dropped
# vscode "apility.beautify-blade"     # no PHP/Blade anywhere
# vscode "james-yu.latex-workshop"    # deferred with cask "basictex" — see above
#
# Redundant:
# vscode "ms-vscode.vscode-typescript-next"   # VS Code ships TypeScript already
# vscode "ritwickdey.liveserver"              # vite/next dev servers cover this
# vscode "ms-azuretools.vscode-containers"    # overlaps docker.docker
# vscode "ms-vscode-remote.remote-containers" # overlaps docker.docker
# vscode "dejmedus.tailwind-sorter"           # prettier plugin sorts classes
# vscode "ecmel.vscode-html-css"              # overlaps the tailwind extension
# vscode "bierner.markdown-mermaid"           # markdown mermaid preview
# vscode "fill-labs.dependi"                  # inline dependency versions
go "github.com/air-verse/air"              # live reload for the Go services
go "honnef.co/go/tools/cmd/staticcheck"    # nvim none-ls.lua:11 diagnostics source

# Trimmed 2026-09-11. Uncomment to bring back.
# go "golang.org/x/tools/gopls"            # redundant — Mason installs its own
# go "mvdan.cc/sh/v3/cmd/shfmt"            # shell formatter; nothing references it
# go "mvdan.cc/sh/v3/cmd/gosh"             # shell interpreter; nothing references it
# go "google.golang.org/protobuf/cmd/protoc-gen-go"   # dropped with brew "protobuf"
# go "google.golang.org/grpc/cmd/protoc-gen-go-grpc"  # dropped with brew "protobuf"
cargo "bat"                  # zshrc:72 — fzf preview in the `inv` alias
cargo "cargo-feature"
cargo "cargo-watch"          # zshrc:71 — the `cargow` alias
cargo "eza"                  # zshrc:59-66 — ls / ll / la / tree aliases
cargo "ripgrep"              # telescope.nvim live_grep depends on it

# Trimmed 2026-09-11. Uncomment to bring back.
# cargo "cargo-audit"        # dependency security advisories
# cargo "cargo-info"         # crate metadata lookup
# cargo "cargo-machete"      # find unused dependencies
# cargo "sccache"            # compile cache — never installed; the one most worth
#                            # reconsidering if Rust rebuild times start to bite
# cargo "sqlx-cli"           # never installed; no sqlx project in the tree
uv "ruff"
npm "corepack"
