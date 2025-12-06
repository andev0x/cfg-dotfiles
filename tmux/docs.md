### TMUX Configuration Guide (macOS & Linux)

> This guide provides a complete setup for TMUX on macOS and Linux, including installation steps, clipboard fixes, plugin usage, CPU display, and troubleshooting.

⸻

**🚀 Features**

	•	Modern TMUX configuration for macOS & Linux
	•	Mouse support (scroll, drag, selection)
	•	Native clipboard copy (pbcopy / xclip / xsel / wl-copy)
	•	Git branch + CPU + username + time in status bar
	•	Better pane navigation + resizing (Vim style)
	•	TPM plugins: resurrect, continuum, cpu
	•	True-color terminal support
	•	Optimized for Neovim users

⸻

#### 📦 Installation

1. Install TMUX

**macOS**
```
brew install tmux
```
**Linux (Debian/Ubuntu)**
```
sudo apt update && sudo apt install tmux -y
```

⸻

2. Install TPM (Tmux Plugin Manager)
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

⸻

3. Install Clipboard Tools

macOS

Already included: pbcopy, pbpaste

Linux (X11)
```
sudo apt install xclip -y        # Recommended
# or
sudo apt install xsel -y
```
Linux (Wayland)
```
sudo apt install wl-clipboard -y
```

⸻

4. Apply the TMUX Configuration

Copy your .tmux.conf into:
```
~/.tmux.conf
```
Then reload:
```
tmux source-file ~/.tmux.conf
```

⸻

#### 🎛️ Plugin Installation (Inside TMUX)

Run:
```
prefix + I
```
(Default prefix = Ctrl+b)

> This installs:

	•	tmux-resurrect
	•	tmux-continuum
	•	tmux-cpu
	•	tpm

⸻

#### 🖱️ Clipboard Behavior

macOS

Selection → clipboard via:
```
pbcopy
```
Linux (X11)

Selection → clipboard via:
```
xclip -selection clipboard
```
Linux (Wayland)

Selection → clipboard via:
```
wl-copy
```
To switch to Wayland clipboard, replace in .tmux.conf:
```
send-keys -X copy-pipe-and-cancel "wl-copy"

```

⸻

#### ⚙️ CPU Display Setup

Test the CPU script manually:
```
~/.tmux/plugins/tmux-cpu/scripts/cpu_percentage.sh
```
Make sure it is executable:
```
chmod +x ~/.tmux/plugins/tmux-cpu/scripts/*.sh
```

⸻

#### 🧪 Troubleshooting

1. Mouse selection not copying

macOS
	•	Works automatically via pbcopy

Linux

Install clipboard tool:
```
sudo apt install xclip -y
```

⸻

2. True color not working

Ensure terminal uses one of:

	•	xterm-256color
	•	alacritty
	•	kitty
	•	wezterm

Test 24-bit color:
```
echo -e "\e[38;2;255;100;0mTRUE COLOR TEST\e[0m"
```

⸻

3. Plugins not loading

Inside tmux:
```
prefix + I
prefix + r
```

⸻

4. CPU widget missing
Ensure scripts are executable:
```
chmod +x ~/.tmux/plugins/tmux-cpu/scripts/*.sh
tmux source-file ~/.tmux.conf
```

⸻

#### 🏁 Recommended Terminals

	•	Kitty (best performance)
	•	WezTerm (GPU accelerated)
	•	Alacritty (fast + minimal)
	•	GNOME Terminal
	•	Konsole

> All support tmux + true color extremely well.

⸻

#### 📌 Notes
	•	macOS uses pbcopy; Linux uses X11 or Wayland clipboards.
	•	CPU display is enabled through tmux-cpu plugin.
	•	All navigation bindings follow Vim motion logic.



