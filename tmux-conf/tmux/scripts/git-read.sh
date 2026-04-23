#!/usr/bin/env bash

# Read cached git branch (fast, no git call)

dir="$1"
[ -z "$dir" ] && dir="$PWD"

if command -v md5sum >/dev/null 2>&1; then
  key=$(echo "$dir" | md5sum | cut -d ' ' -f1)
else
  key=$(echo "$dir" | md5)
fi

cache="/tmp/tmux_git_$key"

[ -f "$cache" ] && cat "$cache"
