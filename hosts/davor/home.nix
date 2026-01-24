{ config, pkgs, ... }:

{
  imports = [
    ../../shared/home.nix
  ];

  home.sessionVariables = {
    PNPM_HOME = "$HOME/.local/share/pnpm";
  };
  home.sessionPath = [ "$HOME/.local/share/pnpm" ];

  home.packages = with pkgs; [
    # Monitoring (Linux specific tools)
    iotop
    wl-clipboard
    iftop
    strace
    ltrace
    lsof

    # Games
    heroic

    # Hyprland Ecosystem
    waybar
    dunst
    wofi
    hyprpaper
    kitty
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Q, exec, ghostty"
        "$mod, M, exit"
        "$mod, space, exec, wofi --show drun"
      ];
    };
  };

  programs.wofi = import ./wofi.nix { inherit pkgs; };
  programs.waybar = import ./waybar.nix { inherit pkgs; };

  programs.ghostty = {
    settings = {
      font-size = 12;
    };
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  programs.zsh = {
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/#davor";
    };
  };

  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "wl-copy"
  '';
}
