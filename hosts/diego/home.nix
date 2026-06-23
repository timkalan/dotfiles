{
  config,
  lib,
  pkgs,
  ...
}:

let
  devonSshPort = 2223;
  devon = pkgs.callPackage ../../scripts/devon-vfkit.nix { sshPort = devonSshPort; };
in
{
  imports = [
    ../../shared/home.nix
  ];

  home = {
    sessionVariables = {
      PNPM_HOME = "$HOME/Library/pnpm";
    };
    sessionPath = [ "$HOME/Library/pnpm" ];
    packages = [
      devon
    ]
    ++ (with pkgs; [
      colima
      docker-client
      docker-compose
    ]);
    activation.colimaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run install -Dm644 ${../../configs/colima.yaml} "${config.xdg.configHome}/colima/default/colima.yaml"
    '';
  };

  programs = {
    ssh.settings = {
      "*".IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      "devon" = {
        HostName = "localhost";
        Port = devonSshPort;
        ForwardAgent = true;
      };
    };

    git.settings.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

    ghostty = {
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

    zsh.shellAliases = {
      rebuild = "sudo darwin-rebuild switch --flake ~/dotfiles";
    };

    tmux.extraConfig = ''
      bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "pbcopy"
    '';
  };

  xdg.configFile = {
    "aerospace/aerospace.toml".source = ../../configs/aerospace/aerospace.toml;

    "lazygit/config.yml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Application Support/lazygit/config.yml";
  };

}
