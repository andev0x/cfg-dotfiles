# =========================================================
# ⚡ Powerlevel10k Instant Prompt (must stay at top)
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
#  Oh My Zsh Configuration
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
#  PATH Management (Zsh-native, no duplicates)
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
#  Language & Toolchains
# =========================================================

# ----  Bun ----
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ----  Golang ----
export GOPATH="$HOME/go"

# ----  Java (safe load) ----
if command -v /usr/libexec/java_home &> /dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null)
  [ -n "$JAVA_HOME" ] && path+=($JAVA_HOME/bin)
fi

# ----  Android SDK (safe load) ----
export ANDROID_HOME="$HOME/Library/Android/sdk"
[ -d "$ANDROID_HOME" ] && path+=(
  $ANDROID_HOME/platform-tools
  $ANDROID_HOME/emulator
  $ANDROID_HOME/tools
  $ANDROID_HOME/tools/bin
)

# ----  Flutter & Ruby Gems ----
path+=(
  $HOME/flutter/bin
  $HOME/.gem/bin
)

# =========================================================
# ⚡ Lazy Load Heavy Tools (faster shell startup)
# =========================================================

# ----  NVM (lazy load) ----
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# ----  rbenv (lazy load) ----
rbenv() {
  unset -f rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# =========================================================
#  History Configuration (optimized + secure)
# =========================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY_TIME
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_IGNORE_SPACE

#  Prevent sensitive commands from being stored
function zshaddhistory() {
  emulate -L zsh
  [[ "$1" == *"password"* || "$1" == *"secret"* || "$1" == *"token"* ]] && return 1
  return 0
}

# =========================================================
#  Aliases
# =========================================================

# ----  Editor ----
alias vim="nvim"

# ----  Docker ----
alias dcup="docker compose up -d"
alias dcstop="docker compose stop"
alias lzd="lazydocker"

# ----  Utility ----
alias cl="clear"

# ----  Config ----
alias edit-zsh="nvim ~/.zshrc"
alias reload-zsh="source ~/.zshrc"

# ----  Ghostty ----
alias ghostty-config='nvim ~/Library/Application\ Support/com.mitchellh.ghostty/config'

# ----  Clean history (deduplicate safely) ----
alias clean-history='cp ~/.zsh_history ~/.zsh_history.bak && awk -F ";" "!seen[$2]++" ~/.zsh_history > ~/.zsh_history_clean && mv ~/.zsh_history_clean ~/.zsh_history && fc -R ~/.zsh_history'

# ----  eza (modern ls) ----
if command -v eza &> /dev/null; then
  alias l="eza -l --icons --git -a"
  alias lt="eza --tree --level=2 --long --icons --git"
else
  alias l="ls -lah"
fi

# =========================================================
#  FZF (fuzzy finder)
# =========================================================
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# =========================================================
#  Smart Navigation
# =========================================================
eval "$(zoxide init zsh)"

# =========================================================
#  Atuin (advanced shell history)
# =========================================================
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# =========================================================
#  Load Environment Secrets (safe)
# =========================================================
[ -f "$HOME/.env_openai_cli" ] && source "$HOME/.env_openai_cli"
[ -f "$HOME/.env_gemini_cli" ] && source "$HOME/.env_gemini_cli"

# =========================================================
#  Tmux Auto Attach (interactive only)
# =========================================================
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [[ $- == *i* ]]; then
  tmux attach -t andev0x || tmux new -s andev0x
fi

# =========================================================
#  Powerlevel10k Config
# =========================================================
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

