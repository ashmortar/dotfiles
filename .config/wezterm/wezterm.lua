local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	window_close_confirmation = "NeverPrompt",
	font = wezterm.font("Hasklug Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" }),
	-- color_scheme = "Gruvbox Dark Modern Hybrid",
	colors = {
		-- Base colors leaning towards Gruvbox with Dark Modern influence
		foreground = "#EBDBB2", -- Gruvbox light foreground
		background = "#1D2021", -- Gruvbox dark background, slightly darker
		cursor_bg = "#D65D0E", -- Gruvbox orange
		cursor_border = "#D65D0E",
		cursor_fg = "#1D2021",
		selection_bg = "#504945", -- Gruvbox dark selection
		selection_fg = "#EBDBB2",

		-- ANSI colors: A mix of Gruvbox and Dark Modern
		ansi = {
			"#282828", -- Black (Gruvbox)
			"#CC241D", -- Red (Gruvbox)
			"#98971A", -- Green (Gruvbox)
			"#D79921", -- Yellow (Gruvbox)
			"#2472C8", -- Blue (Dark Modern)
			"#B16286", -- Magenta (Gruvbox)
			"#689D6A", -- Cyan (Gruvbox)
			"#A89984", -- White (Gruvbox)
		},
		brights = {
			"#928374", -- Bright Black (Gruvbox)
			"#FB4934", -- Bright Red (Gruvbox)
			"#B8BB26", -- Bright Green (Gruvbox)
			"#FABD2F", -- Bright Yellow (Gruvbox)
			"#3B8EEA", -- Bright Blue (Dark Modern)
			"#D3869B", -- Bright Magenta (Gruvbox)
			"#8EC07C", -- Bright Cyan (Gruvbox)
			"#EBDBB2", -- Bright White (Gruvbox)
		},

		-- Tab bar: Influenced by Dark Modern but with Gruvbox colors
		tab_bar = {
			background = "#1D2021", -- Gruvbox dark background
			active_tab = {
				bg_color = "#504945", -- Gruvbox dark gray
				fg_color = "#EBDBB2", -- Gruvbox light foreground
			},
			inactive_tab = {
				bg_color = "#1D2021", -- Gruvbox dark background
				fg_color = "#928374", -- Gruvbox gray
			},
			inactive_tab_hover = {
				bg_color = "#3C3836", -- Gruvbox dark gray (slightly lighter)
				fg_color = "#EBDBB2", -- Gruvbox light foreground
			},
			new_tab = {
				bg_color = "#1D2021", -- Gruvbox dark background
				fg_color = "#928374", -- Gruvbox gray
			},
			new_tab_hover = {
				bg_color = "#3C3836", -- Gruvbox dark gray (slightly lighter)
				fg_color = "#EBDBB2", -- Gruvbox light foreground
			},
		},
	},
	window_frame = {
		font = wezterm.font("Hasklug Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" }),
	},
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
	},
	window_decorations = "RESIZE",
	initial_cols = 120,
	initial_rows = 40,
}
return config
