# =========================================================
# ⚡ Zsh Configuration - Fast, Clean & Productive (2026)
# Author: andev0x (optimized)
# =========================================================

# =========================================================
# Core Environment & Clean PATH
# =========================================================
export LANG="en_US.UTF-8"
export EDITOR="nvim"

# Ensure unique PATH entries
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
# Antidote Plugin Manager (Static Loading)
# =========================================================
ANTIDOTE_DIR="/opt/homebrew/opt/antidote/share/antidote"

if [[ -f "$ANTIDOTE_DIR/antidote.zsh" ]]; then
  source "$ANTIDOTE_DIR/antidote.zsh"

  # Generate static plugin bundle if needed
  _static_plugins="${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"
  if [[ ! -f "$_static_plugins" || ~/.zsh_plugins.txt -nt "$_static_plugins" ]]; then
    antidote bundle < ~/.zsh_plugins.txt > "$_static_plugins"
  fi

  # Load plugins
  source "$_static_plugins"
else
  print -u2 "⚠️ Antidote not found. Run: brew install antidote"
fi

# =========================================================
# Toolchains
# =========================================================
export GOPATH="$HOME/go"
export BUN_INSTALL="$HOME/.bun"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Java (lazy safe setup)
if command -v /usr/libexec/java_home &>/dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null)
  [[ -n "$JAVA_HOME" ]] && path+=($JAVA_HOME/bin)
fi

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
[[ -d "$ANDROID_HOME" ]] && path+=(
  $ANDROID_HOME/platform-tools
  $ANDROID_HOME/emulator
)

# =========================================================
# Lazy Loaders (Performance Optimization)
# =========================================================

# --- Node (nvm lazy load) ---
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx yarn pnpm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() { nvm && node "$@"; }
npm()  { nvm && npm  "$@"; }
npx()  { nvm && npx  "$@"; }
yarn() { nvm && yarn "$@"; }

# --- Ruby (rbenv lazy load) ---
rbenv() {
  unset -f rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# =========================================================
# History (Secure & Optimized)
# =========================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY_TIME HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS \
       HIST_FIND_NO_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE

# Prevent sensitive data from being stored
zshaddhistory() {
  emulate -L zsh
  [[ "$1" == *"password"* || "$1" == *"secret"* || "$1" == *"token"* ]] && return 1
  return 0
}

# =========================================================
# Completions (Optimized rebuild)
# =========================================================
autoload -Uz compinit && zmodload zsh/complist

# Rebuild completion dump once per day
if [[ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null || echo 0)" ]]; then
  compinit
else
  compinit -C
fi

# =========================================================
# Lazy Tools
# =========================================================

# fzf (if installed)
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# zoxide (lazy load on first use)
z() {
  unfunction z
  eval "$(zoxide init zsh)"
  z "$@"
}

# Atuin (lazy load on Ctrl+R)
if command -v atuin &>/dev/null; then
  _atuin_lazy() {
    unfunction _atuin_lazy
    eval "$(atuin init zsh --disable-up-arrow)"
    zle atuin-search
  }
  zle -N atuin-search _atuin_lazy
  bindkey '^R' atuin-search
fi

# =========================================================
# Aliases
# =========================================================
alias v="nvim"
alias cl="clear"

alias edit-zsh="nvim ~/.zshrc"
alias reload-zsh="exec zsh"

alias ghostty-config='nvim ~/Library/Application\ Support/com.mitchellh.ghostty/config.ghostty'

# Go
alias grun="go run main.go"
alias gbuild="go build ./..."

# Homebrew
alias bup="brew update && brew upgrade && brew cleanup && brew doctor"

# Docker
alias dcup="docker compose up -d"
alias dcstop="docker compose stop"
alias dlog="docker logs -f"
alias lzd="lazydocker"

# File listing
if command -v eza &>/dev/null; then
  alias l="eza -l --icons --git -a"
  alias lt="eza --tree --level=2 --long --icons --git"
else
  alias l="ls -lah"
fi

# Nushell helpers
alias nu-run='nu -c'
nuj() { nu -c "from json | ($1)" }
alias logs-json='docker logs | nu -c "from json"'

# =========================================================
# DEV Cockpit (tmux workspace)
# =========================================================
dev() {
  if ! tmux has-session -t dev 2>/dev/null; then
    tmux new-session -d -s dev -n coding
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
# Auto Tmux (Safe attach)
# =========================================================
if [[ $- == *i* && -z "$TMUX" && -z "$SSH_CONNECTION" && -z "$VSCODE_PID" ]]; then
  if command -v tmux &>/dev/null; then
    tmux new -A -s andev0x 2>/dev/null || true
  fi
fi

# =========================================================
# Secrets (optional)
# =========================================================
[[ -f "$HOME/.env_openai_cli" ]] && source "$HOME/.env_openai_cli"
[[ -f "$HOME/.env_gemini_cli" ]] && source "$HOME/.env_gemini_cli"

# =========================================================
# Starship Prompt (MUST BE LAST)
# =========================================================
eval "$(starship init zsh)"

