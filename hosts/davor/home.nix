{ config, pkgs, ... }:

{
  imports = [
    ../../shared/home.nix
  ];

  home.packages = with pkgs; [
    # Monitoring (Linux specific tools)
    iotop
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

  # Assuming you have these files in hosts/davor/ or similar
  # If they are simple, you can inline them here too.
  programs.wofi = import ./wofi.nix { inherit pkgs; };
  programs.waybar = import ./waybar.nix { inherit pkgs; };

  programs.ghostty = {
    # Package is automagically handled by shared enable=true + pkgs.ghostty default
    # We only override font size here if it differs from Mac
    settings = {
      font-size = 12; # Your Mac config uses 14, so this override keeps Linux smaller
    };
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  programs.zsh = {
    shellAliases = {
      # This alias is super helpful on Linux
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/#davor";

      # 'ls' and 'tree' aliases might duplicate shared/home.nix or shared/configs/.zshrc
      # Check if you already have them there!
    };
    # The plugins (vi-mode) might be better in shared/home.nix if you want them on Mac too!
  };
}
