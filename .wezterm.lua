local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "GruvboxDark"

config.font = wezterm.font("MesloLGL Nerd Font Mono")
config.font_size = 12.0

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

return config
