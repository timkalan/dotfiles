-- Float utility windows
hl.window_rule({ match = { class = "pavucontrol" }, float = true })
hl.window_rule({ match = { class = "blueberry.py" }, float = true })
hl.window_rule({ match = { class = ".blueman-manager-wrapped" }, float = true })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
hl.window_rule({ match = { title = "^(Open File)$" }, float = true })
hl.window_rule({ match = { title = "^(Save File)$" }, float = true })

-- Steam
hl.window_rule({ match = { class = "steam" }, float = true })
hl.window_rule({ match = { class = "steam", title = "^(Friends List)$" }, float = true })

-- 1Password
hl.window_rule({ match = { class = "1Password" }, float = true })

-- Clipse clipboard popup
hl.window_rule({
	match = { class = "com.mitchellh.ghostty", title = "clipse" },
	float = true,
	size = { 622, 652 },
	stay_focused = true,
})

-- nmtui network popup
hl.window_rule({
	match = { class = "com.mitchellh.ghostty", title = "nmtui" },
	float = true,
	size = { 622, 500 },
	stay_focused = true,
})

-- Full opacity for video / games
local full_opacity = "1.0 override 1.0 override"
hl.window_rule({ match = { class = "firefox" }, opacity = full_opacity })
hl.window_rule({ match = { class = "^(steam_app_.*)$" }, opacity = full_opacity })
hl.window_rule({ match = { title = "^(.*YouTube.*)$" }, opacity = full_opacity })
hl.window_rule({ match = { fullscreen = true }, opacity = full_opacity })

-- Blur behind waybar
hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.3 })
