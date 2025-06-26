local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Performance
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- Appearance
config.color_scheme = "tokyonight"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.0
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false

-- OS-specific settings
if os.getenv("WSL_DISTRO_NAME") then
	config.default_domain = "WSL:Ubuntu"
end

config.default_prog = { "/bin/zsh", "-l" }

return config
