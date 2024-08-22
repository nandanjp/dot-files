# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Environment Variables
export EDITOR=nvim
export VISUAL=nvim
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

[ -f "/Users/nandanpatel/.ghcup/env" ] && source "/Users/nandanpatel/.ghcup/env" # ghcup-env
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# Plugins
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-cargo-completion/zsh-cargo-completion.plugin.zsh
source ~/.zsh/plugins/zsh-haskell/haskell.plugin.zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Homebrew auto-suggestions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# Aliases
# exa aliases
alias ls='eza --group-directories-first --icons'

if eza --version | grep -q '+git';
then
	alias ll='ls -lh --git'
else
	alias ll='ls -lh'
fi

alias la='ll -a'
alias tree='ll --tree --level=2'

# other aliases
alias vim=nvim
alias python=python3
alias zrc="$EDITOR $HOME/.zshrc" #alias to edit zshrc
alias cargow="cargo watch -q -c -w src/ -x run"

# vi keybind
bindkey -v

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#set fzf keybindings
source <(fzf --zsh)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt appendhistory

eval "$(rbenv init - zsh)"
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ "$TERM_PROGRAM" == "CodeEditApp_Terminal" ]] && . "/Applications/CodeEdit.app/Contents/Resources/codeedit_shell_integration.zsh"

# Key Bindings
# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
