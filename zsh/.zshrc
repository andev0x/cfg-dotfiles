# =======================================================
# # ⚡ Powerlevel10k Instant Prompt (must stay at top)
# =========================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================================
#  Core Environment
# =========================================================
export LANG="en_US.UTF-8"
export EDITOR="nvim"

# =========================================================
# ⚡ Oh My Zsh
# =========================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  web-search
)

source "$ZSH/oh-my-zsh.sh"

# =========================================================
#  PATH (clean & deduplicated)
# =========================================================
typeset -U path PATH

path=(
  $HOME/.local/bin
  $HOME/.lmstudio/bin
  $HOME/.bun/bin
  $HOME/go/bin
  /usr/local/go/bin
  $path
)

export PATH

# =========================================================
#  Toolchains
# =========================================================
export GOPATH="$HOME/go"

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Java
if command -v /usr/libexec/java_home &> /dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null)
  [ -n "$JAVA_HOME" ] && path+=($JAVA_HOME/bin)
fi

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
[ -d "$ANDROID_HOME" ] && path+=(
  $ANDROID_HOME/platform-tools
  $ANDROID_HOME/emulator
)

# Extra tools
path+=(
  $HOME/flutter/bin
  $HOME/.gem/bin
)

# =========================================================
# ⚡ Lazy Load (fast startup)
# =========================================================
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

rbenv() {
  unset -f rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# =========================================================
#  History (secure + optimized)
# =========================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY_TIME
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

zshaddhistory() {
  emulate -L zsh
  [[ "$1" == *"password"* || "$1" == *"secret"* || "$1" == *"token"* ]] && return 1
  return 0
}

# =========================================================
# ⚡ FZF + Completion
# =========================================================
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"
autoload -Uz compinit && compinit
[ -f ~/.fzf-tab.zsh ] && source ~/.fzf-tab.zsh

# =========================================================
#  Navigation
# =========================================================
eval "$(zoxide init zsh)"

# =========================================================
#  Atuin (history search)
# =========================================================
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
  bindkey '^R' atuin-search 2>/dev/null
fi

# =========================================================
#  Nushell Integration
# =========================================================
alias nu-run='nu -c'

nuj() {
  nu -c "from json | $1"
}

alias logs-json='docker logs | nu -c "from json"'

# =========================================================
#  Aliases
# =========================================================
alias vim="nvim"
alias code="nvim ."
alias cl="clear"

# Go
alias grun="go run main.go"
alias gbuild="go build ./..."

# Brew
alias bup="brew update && brew upgrade && brew cleanup && brew doctor"

# Docker
alias dcup="docker compose up -d"
alias dcstop="docker compose stop"
alias dlog="docker logs -f"
alias lzd="lazydocker"

# eza
if command -v eza &> /dev/null; then
  alias l="eza -l --icons --git -a"
  alias lt="eza --tree --level=2 --long --icons --git"
else
  alias l="ls -lah"
fi

# Config
alias edit-zsh="nvim ~/.zshrc"
alias reload-zsh="source ~/.zshrc"

# =========================================================
#  DEV COCKPIT (tmux automation)
# =========================================================
dev() {
  tmux has-session -t dev 2>/dev/null

  if [ $? != 0 ]; then
    tmux new-session -d -s dev -n code
    tmux send-keys -t dev 'cd ~/projects && nvim .' C-m

    tmux split-window -h -t dev
    tmux send-keys -t dev 'grun' C-m

    tmux split-window -v -t dev
    tmux send-keys -t dev 'nu' C-m

    tmux select-pane -t 0
  fi

  tmux attach -t dev
}

# =========================================================
#  Secrets
# =========================================================
[ -f "$HOME/.env_openai_cli" ] && source "$HOME/.env_openai_cli"
[ -f "$HOME/.env_gemini_cli" ] && source "$HOME/.env_gemini_cli"

# =========================================================
# ⚡ Auto tmux attach
# =========================================================
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [[ $- == *i* ]]; then
  tmux attach -t andev0x || tmux new -s andev0x
fi

# =========================================================
#  Powerlevel10k
# =========================================================
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

