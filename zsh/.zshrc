
### ========================
### Powerlevel10k Instant Prompt
### ========================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### ========================
### Oh My Zsh & Theme
### ========================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)
source $ZSH/oh-my-zsh.sh

### ========================
### Preferred Editor
### ========================
export EDITOR=nvim
alias vim='nvim'

### ========================
### Aliases
### ========================
alias dcup="docker compose up -d"
alias dcstop="docker compose stop"
alias lzd="lazydocker"
alias ghostty-config='nvim ~/Library/Application\ Support/com.mitchellh.ghostty/config'

### ========================
### Bun
### ========================
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

### ========================
### rbenv
### ========================
eval "$(rbenv init -)"

### ========================
### Java & Android SDK
### ========================
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$PATH:$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin"

### ========================
### Flutter & Ruby Gems
### ========================
export PATH="$PATH:$HOME/flutter/bin:$HOME/.gem/bin:$HOME/Documents/Project/Flutter/Lib/flutter/bin"

### ========================
### Node Version Manager (NVM)
### ========================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

### ========================
### Golang
### ========================
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

### ========================
### Zsh History Config
### ========================
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY       # Append history immediately
setopt SHARE_HISTORY            # Share across sessions
setopt HIST_EXPIRE_DUPS_FIRST   # Expire oldest duplicates first
setopt HIST_IGNORE_ALL_DUPS     # Don’t store duplicates
setopt HIST_FIND_NO_DUPS        # Skip dups in reverse search
setopt HIST_REDUCE_BLANKS       # Trim extra blanks
setopt HIST_VERIFY              # Confirm before reuse
setopt HIST_IGNORE_SPACE        # Ignore cmds starting with space

# Prevent sensitive commands from being stored
function zshaddhistory() {
  emulate -L zsh
  [[ "$1" == *"password"* || "$1" == *"passwd"* || "$1" == *"secret"* ]] && return 1
  return 0
}

### ========================
### Tmux Auto Attach
### ========================
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t andev0x || tmux new-session -s andev0x
fi

### ========================
### Atuin (smart history)
### ========================
if command -v atuin &> /dev/null; then
   eval "$(atuin init zsh --disable-up-arrow)"
fi

### ========================
### Other Tools
### ========================
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
. "$HOME/.atuin/bin/env"
eval "$(zoxide init zsh)"

# API Keys
[ -f "$HOME/.env_gemini_cli" ] && source "$HOME/.env_gemini_cli"
[ -f "$HOME/.env_openai_cli" ] && source "$HOME/.env_openai_cli"

# LM Studio CLI
export PATH="$PATH:/Users/anvndev/.lmstudio/bin"
