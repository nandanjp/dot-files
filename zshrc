# Powerlevel10k instant prompt. Must stay near the top; anything requiring
# console input (passwords, [y/n] prompts) must go above this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Environment Variables
export EDITOR=nvim
export VISUAL=nvim

export GOPATH="$HOME/go"
export PNPM_HOME="$HOME/Library/pnpm"

export PATH="$PATH:/opt/homebrew/sbin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$HOME/.local/bin:$PATH"   # uv tool installs land here (ruff, ...)
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Tool Init Hooks
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
eval "$(fnm env)"
eval "$(direnv hook zsh)"

# Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-cargo-completion/zsh-cargo-completion.plugin.zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Key Bindings
bindkey -v
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Completion System (fpath must be fully assembled before compinit runs)
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

fpath=(~/.zsh/plugins/docker/ /Applications/kitty.app/Contents/Resources/kitty/shell-integration/zsh/completions /opt/homebrew/share/zsh/site-functions ~/.zsh/plugins/zsh-cargo-completion/src /usr/local/share/zsh/site-functions /usr/share/zsh/site-functions /usr/share/zsh/5.9/functions ~/.docker/completions $fpath)

autoload -Uz compinit
compinit

source <(fzf --zsh)

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt appendhistory

# Aliases
alias ls='eza --group-directories-first --icons'
if eza --version | grep -q '+git'; then
  alias ll='ls -lh --git'
else
  alias ll='ls -lh'
fi
alias la='ll -a'
alias tree='ll --tree --level=2'

alias vim=nvim
alias python=python3
alias zrc="$EDITOR $HOME/.zshrc"
alias cargow='cargo watch -q -c -w src/ -x run'
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

# Theme (run `p10k configure` or edit ~/.p10k.zsh to customize)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Must be sourced last — wraps whatever ZLE widgets already exist at load time.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
