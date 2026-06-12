{ lib, ... }:

{
  imports = [
    ../../shared/home.nix
  ];

  home = {
    sessionVariables = {
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };
    sessionPath = [ "$HOME/.local/share/pnpm" ];
  };

  # Headless guest: the terminal emulator lives on the host.
  programs.ghostty.enable = lib.mkForce false;
}
