{ colors }:

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
  };

  env = [
    "XCURSOR_THEME,Adwaita"
    "XCURSOR_SIZE,24"
  ];
}
