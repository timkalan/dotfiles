local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- colorscheme config
config.color_scheme = "GruvboxDark"

-- font config
config.font = wezterm.font("MesloLGL Nerd Font Mono")
config.font_size = 13.0

-- only resize decorations
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

-- raise max fps
config.max_fps = 120

-- config.disable_default_key_bindings = true
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

return config
