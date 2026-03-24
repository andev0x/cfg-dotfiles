# =========================================================
# ⚡ Powerlevel10k Instant Prompt (MUST BE FIRST)
# Author: andev0x
# =========================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================================
# Core Environment & PATH
# =========================================================
export LANG="en_US.UTF-8"
export EDITOR="nvim"

typeset -U path PATH

path=(
  $HOME/.local/bin
  /opt/homebrew/bin
  $HOME/.bun/bin
  $HOME/go/bin
  /usr/local/go/bin
  $HOME/flutter/bin
  $HOME/.gem/bin
  $path
)
export PATH

# =========================================================
# ⚡ Antidote Plugin Manager
# =========================================================
ANTIDOTE_DIR="/opt/homebrew/opt/antidote/share/antidote"

if [[ -f "$ANTIDOTE_DIR/antidote.zsh" ]]; then
  source "$ANTIDOTE_DIR/antidote.zsh"

  zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
  if [[ ! -f $zsh_plugins || ~/.zsh_plugins.txt -nt $zsh_plugins ]]; then
    antidote bundle < ~/.zsh_plugins.txt > $zsh_plugins
  fi

  source $zsh_plugins
else
  print -u2 "⚠️ Antidote not found (brew install antidote)"
fi

# =========================================================
# Toolchains
# =========================================================
export GOPATH="$HOME/go"

# Bun
export BUN_INSTALL="$HOME/.bun"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Java
if command -v /usr/libexec/java_home &>/dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null)
  [[ -n "$JAVA_HOME" ]] && path+=($JAVA_HOME/bin)
fi

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
[[ -d "$ANDROID_HOME" ]] && path+=(
  $ANDROID_HOME/platform-tools
  $ANDROID_HOME/emulator
)

# =========================================================
# ⚡ Lazy Load (NVM / Ruby)
# =========================================================
export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx yarn pnpm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() { nvm && node "$@" }
npm() { nvm && npm "$@" }
npx() { nvm && npx "$@" }
yarn() { nvm && yarn "$@" }

rbenv() {
  unset -f rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# =========================================================
# History (Secure + Clean)
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
# ⚡ Completions
# =========================================================
autoload -Uz compinit
zmodload zsh/complist

if [[ ! -f ~/.zcompdump || ~/.zcompdump -nt ~/.zshrc ]]; then
  compinit
else
  compinit -C
fi

# =========================================================
# ⚡ Lazy Init Tools (defer execution)
# =========================================================
lazy_load() {
  (( $+functions[$1] )) || eval "$($2)"
}

# Zoxide
z() { unfunction z; eval "$(zoxide init zsh)"; z "$@" }

# Atuin
if command -v atuin &>/dev/null; then
  _atuin_lazy() {
    unfunction _atuin_lazy
    eval "$(atuin init zsh --disable-up-arrow)"
  }
  zle -N atuin-search _atuin_lazy
  bindkey '^R' atuin-search
fi

# FZF
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# =========================================================
# Nushell
# =========================================================
alias nu-run='nu -c'
nuj() { nu -c "from json | ($1)" }

# =========================================================
# Aliases
# =========================================================
alias vim="nvim"
alias code="nvim ."
alias cl="clear"

alias edit-zsh="nvim ~/.zshrc"
alias reload-zsh="source ~/.zshrc"

alias grun="go run main.go"
alias gbuild="go build ./..."

alias bup="brew update && brew upgrade && brew cleanup && brew doctor"

alias dcup="docker compose up -d"
alias dcstop="docker compose stop"
alias dlog="docker logs -f"

if command -v eza &>/dev/null; then
  alias l="eza -l --icons --git -a"
  alias lt="eza --tree --level=2 --long --icons --git"
else
  alias l="ls -lah"
fi

# =========================================================
# DEV COCKPIT (tmux)
# =========================================================
dev() {
  if ! tmux has-session -t dev 2>/dev/null; then
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
# Secrets
# =========================================================
[[ -f "$HOME/.env_openai_cli" ]] && source "$HOME/.env_openai_cli"
[[ -f "$HOME/.env_gemini_cli" ]] && source "$HOME/.env_gemini_cli"

# =========================================================
# ⚡ Auto Tmux (Safe)
# =========================================================
if [[ $- == *i* && -z "$TMUX" && -z "$SSH_CONNECTION" ]]; then
  if command -v tmux &>/dev/null; then
    [[ "$TERM_PROGRAM" != "vscode" ]] && tmux new -A -s andev0x
  fi
fi

# =========================================================
# Powerlevel10k
# =========================================================
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =========================================================
# History Substring Search
# =========================================================
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'

