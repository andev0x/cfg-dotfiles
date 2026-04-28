# =========================================================
# ZSH CONFIG — FINAL (FAST + CLEAN + TMUX OPTIMIZED)
# ==============================================================


# ========================
# 1. CORE ENVIRONMENT
# ========================

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


# ========================
# 2. ANTIDOTE (STATIC LOAD)
# ========================

ANTIDOTE_DIR="/opt/homebrew/opt/antidote/share/antidote"

if [[ -f "$ANTIDOTE_DIR/antidote.zsh" ]]; then
  source "$ANTIDOTE_DIR/antidote.zsh"

  _static_plugins="${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"

  # Regenerate plugin bundle only when needed
  if [[ ! -f "$_static_plugins" || ~/.zsh_plugins.txt -nt "$_static_plugins" ]]; then
    antidote bundle < ~/.zsh_plugins.txt > "$_static_plugins"
  fi

  source "$_static_plugins"
else
  print -u2 "Antidote not found. Install with: brew install antidote"
fi


# ========================
# 3. TOOLCHAINS
# ========================

export GOPATH="$HOME/go"
export BUN_INSTALL="$HOME/.bun"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Java (safe detection)
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


# ========================
# 4. LAZY LOADERS
# ========================

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


# ========================
# 5. HISTORY (SECURE + FAST)
# ========================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY_TIME HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS \
       HIST_FIND_NO_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE

# Prevent sensitive commands from being stored
zshaddhistory() {
  emulate -L zsh
  [[ "$1" == *"password"* || "$1" == *"secret"* || "$1" == *"token"* ]] && return 1
  return 0
}


# ========================
# 6. COMPLETION (CACHED)
# ========================

autoload -Uz compinit && zmodload zsh/complist

# Rebuild completion cache once per day
if [[ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null || echo 0)" ]]; then
  compinit
else
  compinit -C
fi


# ========================
# 7. LAZY TOOLS
# ========================

# fzf
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"
# Remove fzf default history binding (avoid conflict with atuin)
# bindkey -r '^R'

# zoxide (lazy)
z() {
  unfunction z
  eval "$(zoxide init zsh)"
  z "$@"
}

# atuin (lazy on Ctrl+R)
if command -v atuin &>/dev/null; then
  _atuin_lazy() {
    unfunction _atuin_lazy
    eval "$(atuin init zsh --disable-up-arrow)"
    zle atuin-search
  }
  zle -N atuin-search _atuin_lazy
  bindkey '^F' atuin-search
fi


# ========================
# 8. TMUX GIT SYNC (IMPORTANT)
# ========================

# Update tmux git cache on directory change
update_tmux_git() {
  ~/.config/tmux/scripts/git-update.sh "$PWD" &!

  # Force tmux to refresh status line immediately
  if [[ -n "$TMUX" ]]; then
    tmux refresh-client -S >/dev/null 2>&1
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd update_tmux_git

# Run once on shell start
update_tmux_git


# ========================
# 9. ALIASES
# ========================

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


# ========================
# 10. DEV WORKSPACE (TMUX)
# ========================

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


# ========================
# 11. AUTO TMUX ATTACH
# ========================

if [[ $- == *i* && -z "$TMUX" && -z "$SSH_CONNECTION" && -z "$VSCODE_PID" ]]; then
  if command -v tmux &>/dev/null; then
    tmux new -A -s andev0x 2>/dev/null || true
  fi
fi


# ========================
# 12. SECRETS (OPTIONAL)
# ========================

[[ -f "$HOME/.env_openai_cli" ]] && source "$HOME/.env_openai_cli"
[[ -f "$HOME/.env_gemini_cli" ]] && source "$HOME/.env_gemini_cli"


export OPENCODE_API_BASE="http://localhost:11434/v1"

export OPENCODE_MODEL="deepseek-coder-v2:16b-lite-instruct-q4_K_M"

export OPENCODE_API_KEY="ollama"

# ========================
# 13. PANESHIP
# ========================
#source ~/.config/paneship/paneship.zsh

eval "$(paneship init zsh)"

# ========================
# 14. STARSHIP (LAST)
# ========================

# eval "$(starship init zsh)"

