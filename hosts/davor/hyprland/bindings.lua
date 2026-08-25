local mod = "SUPER"

hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mod .. " + O", hl.dsp.exec_cmd("obsidian"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("nautilus --new-window"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("ghostty -e nvim"))
hl.bind(mod .. " + T", hl.dsp.exec_cmd("ghostty -e btop"))
hl.bind(mod .. " + Space", hl.dsp.exec_cmd("walker -H"))
hl.bind(mod .. " + SHIFT + Space", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

hl.bind(mod .. " + C", hl.dsp.exec_cmd("brave --app=https://calendar.google.com"))
hl.bind(mod .. " + M", hl.dsp.exec_cmd("brave --app=https://mail.google.com"))
hl.bind(mod .. " + Y", hl.dsp.exec_cmd("brave --app=https://youtube.com"))
hl.bind(mod .. " + A", hl.dsp.exec_cmd("brave --app=https://music.apple.com"))
hl.bind(mod .. " + I", hl.dsp.exec_cmd("brave --app=https://claude.ai"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("brave --app=https://fb.com/messages"))

hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + V", hl.dsp.window.float())
hl.bind(mod .. " + SHIFT + V", hl.dsp.window.pin())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + U", hl.dsp.focus({ urgent_or_last = true }))

-- Focus movement
hl.bind(mod .. " + Left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + Up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + Down", hl.dsp.focus({ direction = "d" }))

-- Swap windows
hl.bind(mod .. " + SHIFT + Left", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mod .. " + SHIFT + Right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mod .. " + SHIFT + Up", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mod .. " + SHIFT + Down", hl.dsp.window.swap({ direction = "d" }))

-- Resize
hl.bind(mod .. " + Minus", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(mod .. " + Equal", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(mod .. " + SHIFT + Minus", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
hl.bind(mod .. " + SHIFT + Equal", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))

hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Navigate workspaces
hl.bind(mod .. " + Comma", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + Period", hl.dsp.focus({ workspace = "m+1" }))

-- Special workspace (scratchpad)
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mod .. " + G", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mod .. " + SHIFT + G", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mod .. " + CTRL + G", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mod .. " + SHIFT + CTRL + G", hl.dsp.exec_cmd("hyprshot -m output"))

hl.bind("CTRL + " .. mod .. " + V", hl.dsp.exec_cmd("ghostty -e clipse"))

hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + SHIFT + Escape", hl.dsp.exec_cmd("hyprlock & sleep 1 && systemctl suspend"))
hl.bind(mod .. " + CTRL + Escape", hl.dsp.exec_cmd("systemctl reboot"))
hl.bind(mod .. " + SHIFT + CTRL + Escape", hl.dsp.exec_cmd("systemctl poweroff"))

hl.bind(mod .. " + P", hl.dsp.exec_cmd("$HOME/.scripts/toggle-projector.sh"))

-- KVM: hand the shared monitor (+ keyboard/mouse) to the Mac (diego)
hl.bind("CTRL + ALT + K", hl.dsp.exec_cmd("$HOME/.scripts/kvm-switch.sh"))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse bindings
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Locked bindings (work even when screen is locked)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Locked + repeat bindings (hold to keep triggering)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)

-- Repeat bindings (brightness)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })
