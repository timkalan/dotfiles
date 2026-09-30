#!/usr/bin/env bash
# Toggle the HDMI-A-1 projector on/off
# Projector is positioned to the LEFT of the main DP-2 monitor

PROJECTOR="HDMI-A-1"
RESOLUTION="1920x1080@60"
# Negative X offset: projector is 1920px wide, placed to the left
POSITION="-1920x0"

# `monitors all` is required: plain `monitors` omits disabled outputs
STATUS=$(hyprctl monitors all -j | jq -r ".[] | select(.name == \"$PROJECTOR\") | .disabled")

# The Lua config parser rejects `hyprctl keyword`, so rules go through `eval`.
# `disabled` must be set explicitly both ways: rules merge onto monitors.lua,
# which declares the projector disabled.
if [ "$STATUS" = "true" ] || [ -z "$STATUS" ]; then
    hyprctl eval "hl.monitor({ output = '$PROJECTOR', mode = '$RESOLUTION', position = '$POSITION', scale = 1, disabled = false })"
    notify-send "Projector" "Enabled (to the left)" -t 2000
else
    hyprctl eval "hl.monitor({ output = '$PROJECTOR', disabled = true })"
    notify-send "Projector" "Disabled" -t 2000
fi
