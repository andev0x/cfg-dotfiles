# andev0x/cfg-dotfiles

My personal dotfiles for various tools. This repository contains my preferred configurations for a consistent development environment across multiple machines.

## Installation

These dotfiles can be installed by cloning this repository and running the `install.sh` script. This will create symlinks from your home directory to the configuration files in this repository.

**Warning:** The installation script will overwrite existing configuration files. It will create a backup of your current dotfiles in a timestamped directory like `~/.dotfiles_backup_YYYYMMDDHHMMSS` before making any changes.

### Steps

1.  **Clone the repository:**

    It's a good practice to clone it to a hidden directory in your home folder, for example `~/.dotfiles`.

    ```bash
    git clone https://github.com/andev0x/cfg-dotfiles.git ~/.dotfiles
    ```

2.  **Navigate to the repository directory:**

    ```bash
    cd ~/.dotfiles
    ```

3.  **Make the script executable:**

    ```bash
    chmod +x install.sh
    ```

4.  **Run the installation script:**

    ```bash
    ./install.sh
    ```

5.  **Restart your shell or terminal** for the changes to take effect.

## Included Configurations

- Alacritty (Terminal)
- Ghostty (Terminal)
- Neovim (Editor)
- Tmux (Terminal Multiplexer)
- Wezterm (Terminal)
- Zsh (Shell)
