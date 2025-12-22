{ config, pkgs, ... }:

{
  home.username = "timkalan";
  home.homeDirectory = "/home/timkalan";

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.packages = with pkgs; [
    fastfetch

    ripgrep
    fd
    jq
    fzf
    eza
    unzip
    tmux

    btop
    iotop
    iftop

    strace
    ltrace
    lsof

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
  ];

  programs.git = import ./git.nix { inherit pkgs; };

  programs.starship = {
    enable = true;
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
      rebuild = "sudo nixos-rebuild switch --flake .";
      lg = "lazygit";
    };
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
