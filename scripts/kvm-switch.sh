#!/usr/bin/env bash
# Hand the shared monitor (Gigabyte M28U) over to the Mac (diego) via DDC/CI.
# The monitor's built-in KVM follows the active video input, so the keyboard
# and mouse hop to the Mac along with the picture.
#
# MAC_INPUT_CODE is the VCP 0x60 value for the port the Mac is plugged into.
# Read live off the M28U via `m1ddc get input` on the Mac (USB-C): it reports
# 16 (0x10) — the M28U exposes its USB-C input as "DisplayPort 2".
MAC_INPUT_CODE="0x10"

if ddcutil setvcp 0x60 "$MAC_INPUT_CODE"; then
	notify-send "KVM" "Handed monitor to the Mac (diego)" -t 2000
else
	notify-send "KVM" "Switch failed — check ddcutil / input code" -t 3000
fi
