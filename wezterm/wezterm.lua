local wezterm = require("wezterm")

return {
	font = wezterm.font_with_fallback({
		"JetBrainsMono Nerd Font",
		"MesloLGS NF", -- lightweight, icon-friendly
	}),
	font_size = 16,
	line_height = 1.1,
	freetype_load_target = "Light",
	freetype_render_target = "HorizontalLcd",

	-- Disable tab bar and decorations for minimal UI
	enable_tab_bar = false,
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	hide_mouse_cursor_when_typing = true,

	-- Performance tuning
	scrollback_lines = 300,
	adjust_window_size_when_changing_font_size = false,

	-- Terminal appearance
	color_scheme = "Catppuccin Mocha",
	window_background_opacity = 0.1,
	text_background_opacity = 1.0,

	-- Start shell
	default_prog = { "/bin/zsh", "-l" },

	-- Optimized initial size (adjust to your screen)
	initial_cols = 186,
	initial_rows = 48,

	-- Minimal key bindings for pane control
	keys = {
		{ key = "Enter", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "\\", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
		{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	},
}
