{ colors }:

{
  windowrule = [
    # Float utility windows
    "float on, match:class pavucontrol"
    "float on, match:class blueberry.py"
    "float on, match:class .blueman-manager-wrapped"
    "float on, match:class nm-connection-editor"
    "float on, match:title ^(Open File)$"
    "float on, match:title ^(Save File)$"

    # Steam
    "float on, match:class steam"
    "float on, match:class steam, match:title ^(Friends List)$"

    # 1Password
    "float on, match:class 1Password"

    # Clipse clipboard popup
    "float on, match:class com.mitchellh.ghostty, match:title clipse"
    "size 622 652, match:class com.mitchellh.ghostty, match:title clipse"
    "stay_focused on, match:class com.mitchellh.ghostty, match:title clipse"

    # Full opacity for video / games
    "opacity 1.0 override 1.0 override, match:class firefox"
    "opacity 1.0 override 1.0 override, match:class ^(steam_app_.*)$"
    "opacity 1.0 override 1.0 override, match:title ^(.*YouTube.*)$"
    "opacity 1.0 override 1.0 override, match:fullscreen true"
  ];

  layerrule = [
    # Blur behind waybar and wofi
    "blur on, match:namespace waybar"
    "blur on, match:namespace wofi"
    "ignore_alpha 0.3, match:namespace waybar"
    "ignore_alpha 0.3, match:namespace wofi"
  ];
}
