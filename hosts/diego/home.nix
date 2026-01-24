{
  lib,
  ...
}:

{
  imports = [
    ../../shared/home.nix
  ];

  home.sessionVariables = {
    PNPM_HOME = "$HOME/Library/pnpm";
  };
  home.sessionPath = [ "$HOME/Library/pnpm" ];

  programs.ghostty = {
    # We override 'package' to null because on Mac we use the DMG/Brew version.
    package = lib.mkForce null;

    # Add Mac-specific Keybinds
    settings = {
      keybind = [
        "cmd+t=unbind"
        "cmd+w=unbind"
        "cmd+n=unbind"
        "cmd+d=unbind"
        "cmd+shift+d=unbind"
        "cmd+enter=unbind"
      ];
    };
  };

  xdg.configFile."aerospace/aerospace.toml".source = ../../configs/aerospace/aerospace.toml;

  programs.zsh.shellAliases = {
    rebuild = "sudo darwin-rebuild switch --flake ~/dotfiles";
  };

  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "pbcopy"
  '';
}
