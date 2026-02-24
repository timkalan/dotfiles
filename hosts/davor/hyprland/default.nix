{ colors }:

let
  monitors = import ./monitors.nix { inherit colors; };
  autostart = import ./autostart.nix { inherit colors; };
  bindings = import ./bindings.nix { inherit colors; };
  looknfeel = import ./looknfeel.nix { inherit colors; };
  input = import ./input.nix { inherit colors; };
  windows = import ./windows.nix { inherit colors; };
in

monitors
// autostart
// looknfeel
// input
// windows
// bindings
// {
  "$mod" = "SUPER";

  misc = {
    force_default_wallpaper = 0;
    disable_hyprland_logo = true;
  };

  ecosystem = {
    no_update_news = true;
  };
}
