local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "GruvboxDark"

config.font = wezterm.font("MesloLGL Nerd Font Mono")
config.font_size = 13.0

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

-- TEMP fix for perf issue
config.window_background_opacity = 0.999

-- config.disable_default_key_bindings = true
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

return config
