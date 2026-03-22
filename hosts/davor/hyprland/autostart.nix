{
  exec-once = [
    "hyprlock"
    "waybar"
    "swaync"
    "swaybg -i /home/timkalan/Pictures/Wallpapers/wallpaper.jpg -m fill"
    "systemctl --user start hyprpolkitagent"
    "wl-clip-persist --clipboard both"
    "clipse -listen"
  ];

  # Restart waybar on reload (picks up config changes)
  exec = [
    "pkill waybar; waybar"
  ];
}
