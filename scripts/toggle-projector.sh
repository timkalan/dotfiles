#!/usr/bin/env bash
# Toggle the HDMI-A-1 projector on/off
# Projector is positioned to the LEFT of the main DP-2 monitor

PROJECTOR="HDMI-A-1"
RESOLUTION="1920x1080@60"
# Negative X offset: projector is 1920px wide, placed to the left
POSITION="-1920x0"

# Check if projector is currently disabled
STATUS=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$PROJECTOR\") | .disabled")

if [ "$STATUS" = "true" ] || [ -z "$STATUS" ]; then
	# Enable projector to the left of main monitor
	hyprctl keyword monitor "$PROJECTOR, $RESOLUTION, $POSITION, 1"
	notify-send "Projector" "Enabled (to the left)" -t 2000
else
	# Disable projector
	hyprctl keyword monitor "$PROJECTOR, disable"
	notify-send "Projector" "Disabled" -t 2000
fi
