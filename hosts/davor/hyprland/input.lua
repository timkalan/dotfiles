hl.config({
	input = {
		kb_layout = "us",
		follow_mouse = 1,

		touchpad = {
			natural_scroll = true,
		},
	},

	cursor = {
		default_monitor = "DP-2",
		hide_on_key_press = true,
	},
})

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
