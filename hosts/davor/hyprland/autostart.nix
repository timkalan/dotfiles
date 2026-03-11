{
  exec-once = [
    "hyprlock"
    "waybar"
    "mako"
    "swaybg -i $HOME/Pictures/Wallpapers/wallpaper.jpg -m fill"
    "systemctl --user start hyprpolkitagent"
    "wl-clip-persist --clipboard both"
    "clipse -listen"
  ];

  # Restart waybar on reload (picks up config changes)
  exec = [
    "pkill waybar; waybar"
  ];
}
