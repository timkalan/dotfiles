{ lib, colors }:

{
  enable = true;
  configType = "lua";

  # UWSM owns graphical-session.target. home-manager's hyprland-session.target
  # PropagatesStopTo it, so its startup "stop && start" tears down the compositor.
  systemd.enable = false;

  extraLuaFiles = {
    # Shared palette (see ../colors.nix), required by looknfeel.lua
    colors = {
      content = "return " + lib.generators.toLua { } colors;
      autoLoad = false;
    };

    monitors = ./monitors.lua;
    input = ./input.lua;
    misc = ./misc.lua;
    looknfeel = ./looknfeel.lua;
    windows = ./windows.lua;
    autostart = ./autostart.lua;
    bindings = ./bindings.lua;
  };
}
