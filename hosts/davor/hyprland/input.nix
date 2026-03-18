{
  input = {
    kb_layout = "us";
    follow_mouse = 1;

    touchpad = {
      natural_scroll = true;
    };
  };

  cursor = {
    default_monitor = "DP-2";
    hide_on_key_press = true;
  };

  env = [
    "XCURSOR_THEME,Adwaita"
    "XCURSOR_SIZE,24"
  ];
}
