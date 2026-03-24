# =========================================================
# ⚡ Powerlevel10k Instant Prompt (MUST BE FIRST)
# Author: andev0x
# =========================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================================
#  Core Environment & PATH (Clean & Deduplicated)
# =========================================================
export LANG="en_US.UTF-8"
export EDITOR="nvim"

# Force PATH to have unique values only (deduplication)
typeset -U path PATH

# Define all paths upfront. Custom bins and Homebrew take precedence over system bins.
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
# Locate and load Antidote (Assuming installed via Homebrew)
ANTIDOTE_DIR="/opt/homebrew/opt/antidote/share/antidote"
if [[ -f "$ANTIDOTE_DIR/antidote.zsh" ]]; then
  source "$ANTIDOTE_DIR/antidote.zsh"
# Static plugins
  zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
  if [[ ! -f $zsh_plugins || ~/.zsh_plugins.txt -nt $zsh_plugins ]]; then
    antidote bundle < ~/.zsh_plugins.txt > $zsh_plugins
  fi
  source $zsh_plugins
else
  echo "Antidote not found. Run: brew install antidote"
fi

# =========================================================
#  Toolchains & Language Environments
# =========================================================
# Go
export GOPATH="$HOME/go"

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Java (macOS specific)
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

# =========================================================
# ⚡ Lazy Loaders (Zero Startup Penalty)
# =========================================================
# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx yarn pnpm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() { nvm && node "$@" }
npm() { nvm && npm "$@" }
npx() { nvm && npx "$@" }
yarn() { nvm && yarn "$@" }

# rbenv (Ruby)
rbenv() {
  unset -f rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# =========================================================
#  History (Secure & Optimized)
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

# Prevent storing secrets in history
zshaddhistory() {
  emulate -L zsh
  [[ "$1" == *"password"* || "$1" == *"secret"* || "$1" == *"token"* ]] && return 1
  return 0
}

# =========================================================
# ⚡ Completions & CLI Tools
# =========================================================
# FZF (Fuzzy Finder)
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# Fast compinit (Only builds cache once a day to save 0.2s on startup)
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null || echo "0") ]; then
  compinit
else
  compinit -C
fi

# Zoxide (Smart cd)
eval "$(zoxide init zsh)"

# Atuin (Magical shell history)
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
  bindkey '^R' atuin-search 2>/dev/null
fi

# =========================================================
#  Nushell Integration
# =========================================================
alias nu-run='nu -c'
nuj() { nu -c "from json | ($1)" }
alias logs-json='docker logs | nu -c "from json"'

# =========================================================
#  Aliases
# =========================================================
# General
alias vim="nvim"
alias code="nvim ."
alias cl="clear"

# Config
alias edit-zsh="nvim ~/.zshrc"
alias reload-zsh="source ~/.zshrc && antidote update"

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

# Eza (Better ls - modern replacement)
if command -v eza &> /dev/null; then
  alias l="eza -l --icons --git -a"
  alias lt="eza --tree --level=2 --long --icons --git"
else
  alias l="ls -lah"
fi

# =========================================================
#  DEV COCKPIT (Tmux Workspace Automation)
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
#  Secrets & Environment Variables
# =========================================================
[ -f "$HOME/.env_openai_cli" ] && source "$HOME/.env_openai_cli"
[ -f "$HOME/.env_gemini_cli" ] && source "$HOME/.env_gemini_cli"

# =========================================================
# ⚡ Auto Tmux Attach
# Avoids auto-attaching inside IDE terminals (VS Code, JetBrains)
# =========================================================
if [[ $- == *i* && -z "$TMUX" && "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
  if command -v tmux &> /dev/null; then
    # Attach to 'andev0x' session if exists, otherwise create it
    tmux new -A -s andev0x
  fi
fi

# =========================================================
#  Powerlevel10k Configuration
# =========================================================
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# =========================================================
# ⚡ History Substring Search Configuration
# =========================================================
# Bind Up/Down arrows to history search
if [[ -n "${terminfo[kcuu1]}" ]]; then
  bindkey "${terminfo[kcuu1]}" history-substring-search-up
fi
if [[ -n "${terminfo[kcud1]}" ]]; then
  bindkey "${terminfo[kcud1]}" history-substring-search-down
fi

# Bind standard arrow keys for compatibility
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Optional: Color for the matched part
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'

