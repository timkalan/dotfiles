{ colors }:

let
  monitors = import ./monitors.nix;
  autostart = import ./autostart.nix;
  bindings = import ./bindings.nix;
  looknfeel = import ./looknfeel.nix { inherit colors; };
  input = import ./input.nix;
  windows = import ./windows.nix;
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
    focus_on_activate = true;
  };

  binds = {
    hide_special_on_workspace_change = true;
  };

  ecosystem = {
    no_update_news = true;
  };
}
