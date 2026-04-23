#!/usr/bin/env bash

# Update git branch cache for a given directory
# This script is triggered on directory change (cd)

dir="$1"
[ -z "$dir" ] && dir="$PWD"

# Generate cache key (cross-platform)
if command -v md5sum >/dev/null 2>&1; then
  key=$(echo "$dir" | md5sum | cut -d ' ' -f1)
else
  key=$(echo "$dir" | md5)
fi

cache="/tmp/tmux_git_$key"

# Check if inside git repo
git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "" > "$cache"
  exit 0
}

# Get current branch
branch=$(git -C "$dir" symbolic-ref --quiet --short HEAD 2>/dev/null)

# Fallback for detached HEAD
if [ -z "$branch" ]; then
  branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
fi

echo "$branch" > "$cache"
