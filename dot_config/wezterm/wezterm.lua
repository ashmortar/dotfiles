local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Performance
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- Appearance
config.color_scheme = 'tokyonight'
config.font = wezterm.font('JetBrainsMono Nerd Font')
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

-- Keybindings for tmux-like behavior
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- Splitting
  { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- Navigation
  { key = 'h', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Right' },
  
  -- Resize
  { key = 'h', mods = 'ALT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'j', mods = 'ALT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  { key = 'k', mods = 'ALT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'l', mods = 'ALT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
}

-- OS-specific settings
if os.getenv("WSL_DISTRO_NAME") then
  config.default_domain = 'WSL:Ubuntu'
end
return config
