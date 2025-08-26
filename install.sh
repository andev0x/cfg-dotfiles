#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Variables ---
# Get the directory of the script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Create a timestamped backup directory in the home folder
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)"

# --- Helper function ---
# Creates a symlink from a source file/directory to a destination.
# If the destination already exists, it will be moved to the backup directory.
#
# @param $1: Source file/directory (in the dotfiles repo)
# @param $2: Destination file/directory (in the home directory)
create_symlink() {
    local source_path="$1"
    local dest_path="$2"
    local dest_dir

    dest_dir=$(dirname "$dest_path")

    # Create the destination directory if it doesn't exist
    if [ ! -d "$dest_dir" ]; then
        echo "-> Creating directory: $dest_dir"
        mkdir -p "$dest_dir"
    fi

    # If the destination exists (as a file or symlink), back it up
    if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
        echo "-> Backing up existing '$dest_path' to '$BACKUP_DIR'"
        # Create the backup directory if it's the first time
        if [ ! -d "$BACKUP_DIR" ]; then
            mkdir -p "$BACKUP_DIR"
        fi
        # Move the existing file/directory to the backup directory
        mv "$dest_path" "$BACKUP_DIR/"
    fi

    # Create the symlink
    echo "-> Creating symlink: $dest_path -> $source_path"
    ln -s "$source_path" "$dest_path"
}

# --- Main script ---
echo "Starting dotfiles installation..."
echo "Your existing dotfiles will be backed up to: $BACKUP_DIR"
echo ""

# Create symlinks for each configuration
create_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

echo ""
echo "✅ Dotfiles installation complete!"
echo "-> Please restart your shell or terminal for changes to take effect."
