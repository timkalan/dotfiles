-- Main monitor: Gigabyte M28U 4K, 1.5x scale
hl.monitor({
	output = "DP-2",
	mode = "3840x2160@60",
	position = "0x0",
	scale = 1.5,
})

-- Projector: Epson, disabled by default (toggle with SUPER+P)
hl.monitor({
	output = "HDMI-A-1",
	disabled = true,
})
