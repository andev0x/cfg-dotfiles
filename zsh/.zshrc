### Instant Prompt for Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)
source $ZSH/oh-my-zsh.sh

### Preferred Editor
export EDITOR=nvim

### Aliases
alias vim='nvim'
alias dcup="docker compose up -d"
alias dcstop="docker compose stop"
alias lzd="lazydocker"

### Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

### rbenv
eval "$(rbenv init -)"

### Java & Android SDK
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$PATH:$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin"

### Flutter & Ruby Gems
export PATH="$PATH:$HOME/flutter/bin:$HOME/.gem/bin:$HOME/Documents/Project/Flutter/Lib/flutter/bin"

### Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

### Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

### Zsh History Configuration (smart, secure)
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY       # Append history immediately
setopt SHARE_HISTORY            # Share across sessions
setopt HIST_EXPIRE_DUPS_FIRST  # Expire oldest duplicates first
setopt HIST_IGNORE_ALL_DUPS    # Don't store duplicated commands
setopt HIST_FIND_NO_DUPS       # Skip dups in reverse search
setopt HIST_REDUCE_BLANKS      # Remove extra blanks
setopt HIST_VERIFY             # Confirm command before reuse
setopt HIST_IGNORE_SPACE       # Don't store commands starting with space

# Prevent saving sensitive commands in history
function zshaddhistory() {
  emulate -L zsh
  [[ "$1" == *"password"* || "$1" == *"passwd"* || "$1" == *"secret"* ]] && return 1
  return 0
}

# Auto attach tmux if not already inside
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi

# Auto-save tmux session on terminal exit
function save_tmux_session_on_exit {
  if [ -n "$TMUX" ]; then
    tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
  fi
}
trap save_tmux_session_on_exit EXIT


### Atuin (smart history with Ctrl+R, optional)
if command -v atuin &> /dev/null; then
   eval "$(atuin init zsh --disable-up-arrow)"
fi

### Powerlevel10k Config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


. "$HOME/.atuin/bin/env"

# shell like vscode
eval "$(zoxide init zsh)"

# alias ghostty config
alias ghostty-config='nvim ~/Library/Application\ Support/dev.abcxyz.Ghostty/config'


