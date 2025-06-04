local wezterm = require("wezterm")

-- Event: Change window title when using SSH
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	if pane:get_title():find("ssh") then
		return "🔒 SSH: " .. pane:get_title()
	end
	return pane:get_title()
end)

-- Event: Auto-spawn window on GUI startup (if no tmux is used)
wezterm.on("gui-startup", function(cmd)
	local mux = wezterm.mux
	mux.spawn_window(cmd or {})
end)

return {
	-- Font settings with fallback
	font = wezterm.font_with_fallback({
		"JetBrainsMono Nerd Font",
		"MesloLGS NF",
	}),
	font_size = 16,
	line_height = 1.1,
	freetype_load_target = "Light",
	freetype_render_target = "HorizontalLcd",

	-- Disable tab bar and simplify decorations
	enable_tab_bar = false,
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	hide_mouse_cursor_when_typing = true,

	-- Appearance and color
	color_scheme = "gotham",
	window_background_opacity = 0.01,
	text_background_opacity = 1.0,

	-- Initial window size
	initial_cols = 186,
	initial_rows = 48,

	-- Performance tweaks
	scrollback_lines = 300,
	adjust_window_size_when_changing_font_size = false,

	-- Use Zsh and auto start or attach to a tmux session
	default_prog = { "/bin/zsh", "-l", "-c", "tmux new-session -A -s main" },

	-- Dim inactive panes
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.6,
	},

	-- Key bindings for pane management (similar to tmux)
	keys = {
		-- Split pane horizontally (Alt + Enter)
		{ key = "Enter", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

		-- Split pane vertically (Alt + \)
		{ key = "\\", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

		-- Close current pane (Cmd + W)
		{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

		-- Navigate between panes (Alt + hjkl)
		{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	},
}
