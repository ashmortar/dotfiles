local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	window_close_confirmation = "NeverPrompt",
	font = wezterm.font("Hasklug Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" }),
	color_scheme = "Gruvbox Dark (Gogh)",
	window_frame = {
		font = wezterm.font("Hasklug Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" }),
	},
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
	},
	window_decorations = "RESIZE",
}
return config
