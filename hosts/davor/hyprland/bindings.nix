{
  bind = [
    "$mod, Return, exec, ghostty"
    "$mod, B, exec, firefox"
    "$mod, O, exec, obsidian"
    "$mod, E, exec, nautilus --new-window"
    "$mod, N, exec, ghostty -e nvim"
    "$mod, T, exec, ghostty -e btop"
    "$mod, Space, exec, walker -H"
    "$mod SHIFT, Space, exec, pkill -SIGUSR1 waybar"

    "$mod, C, exec, brave --app=https://calendar.google.com"
    "$mod, M, exec, brave --app=https://mail.google.com"
    "$mod, Y, exec, brave --app=https://youtube.com"
    "$mod, A, exec, brave --app=https://music.apple.com"

    "$mod, W, killactive"
    "$mod, F, fullscreen"
    "$mod, V, togglefloating"
    "$mod SHIFT, V, pin"
    "$mod, J, togglesplit"
    "$mod, U, focusurgentorlast"

    # Focus movement
    "$mod, Left, movefocus, l"
    "$mod, Right, movefocus, r"
    "$mod, Up, movefocus, u"
    "$mod, Down, movefocus, d"

    # Swap windows
    "$mod SHIFT, Left, swapwindow, l"
    "$mod SHIFT, Right, swapwindow, r"
    "$mod SHIFT, Up, swapwindow, u"
    "$mod SHIFT, Down, swapwindow, d"

    # Resize
    "$mod, Minus, resizeactive, -40 0"
    "$mod, Equal, resizeactive, 40 0"
    "$mod SHIFT, Minus, resizeactive, 0 -40"
    "$mod SHIFT, Equal, resizeactive, 0 40"

    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    "$mod, 0, workspace, 10"

    "$mod SHIFT, 1, movetoworkspace, 1"
    "$mod SHIFT, 2, movetoworkspace, 2"
    "$mod SHIFT, 3, movetoworkspace, 3"
    "$mod SHIFT, 4, movetoworkspace, 4"
    "$mod SHIFT, 5, movetoworkspace, 5"
    "$mod SHIFT, 6, movetoworkspace, 6"
    "$mod SHIFT, 7, movetoworkspace, 7"
    "$mod SHIFT, 8, movetoworkspace, 8"
    "$mod SHIFT, 9, movetoworkspace, 9"
    "$mod SHIFT, 0, movetoworkspace, 10"

    # Navigate workspaces
    "$mod, Comma, workspace, m-1"
    "$mod, Period, workspace, m+1"

    # Special workspace (scratchpad)
    "$mod, S, togglespecialworkspace, magic"
    "$mod SHIFT, S, movetoworkspace, special:magic"

    "$mod, G, exec, hyprshot -m region --clipboard-only"
    "$mod SHIFT, G, exec, hyprshot -m region"
    "$mod CTRL, G, exec, hyprpicker -a"
    "$mod SHIFT CTRL, G, exec, hyprshot -m output"

    "CTRL $mod, V, exec, ghostty -e clipse"

    "$mod, Escape, exec, hyprlock"
    "$mod SHIFT, Escape, exec, hyprlock & sleep 1 && systemctl suspend"
    "$mod CTRL, Escape, exec, systemctl reboot"
    "$mod SHIFT CTRL, Escape, exec, systemctl poweroff"

    "$mod, P, exec, $HOME/.scripts/toggle-projector.sh"

    "$mod, mouse_down, workspace, e+1"
    "$mod, mouse_up, workspace, e-1"
  ];

  # Mouse bindings
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  # Locked bindings (work even when screen is locked)
  bindl = [
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPrev, exec, playerctl previous"
  ];

  # Locked + repeat bindings (hold to keep triggering)
  bindel = [
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  ];

  # Repeat bindings (brightness)
  binde = [
    ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
    ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
  ];

}
