{ config, pkgs, ... }:

{
  home.username = "timkalan";
  home.homeDirectory = "/home/timkalan";

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.packages = with pkgs; [
    # vanity
    fastfetch

    # useful tools
    ripgrep
    fd
    jq
    fzf
    eza
    zoxide
    unzip
    tmux

    # monitoring
    btop
    iotop
    iftop
    strace
    ltrace
    lsof

    # git
    gh
    lazygit

    # I added all of these to make nvim config work
    rustup
    go
    nodejs_24
    gcc
    gnumake
    lua
    python314
    nixfmt

    # games
    heroic

    # hyprland
    waybar
    dunst
    wofi
    hyprpaper
    kitty # TODO: can i remove this?
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

  programs.git = import ./git.nix { inherit pkgs; };

  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-size = 12;
      theme = "Gruvbox Dark";
      window-padding-balance = true;

      mouse-hide-while-typing = true;
      copy-on-select = true;
      window-save-state = "always";
      shell-integration = "detect";
      shell-integration-features = "cursor, sudo, title";
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/";
      lg = "lazygit";
      ls = "eza -lahF --git --icons";
      tree = "tree -C";
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/timkalan/dotfiles/.config/nvim";

  home.stateVersion = "25.11";
}
