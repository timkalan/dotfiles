{ config, pkgs, ... }:

{
  # The version of Home Manager you are using.
  home.stateVersion = "25.11";

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    cowsay
    starship
  ];

  programs.git = {
    enable = true;

    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Tim Kalan";
        email = "timkalan99@gmail.com";

      };
      gpg.format = "ssh";

      url."git@github.com:".insteadOf = "https://github.com/";
    };

    ignores = [
      ".DS_Store"
      ".env"
    ];

    includes = [
      {
        # If the directory matches this path...
        condition = "gitdir:~/projects/work/";
        # ...apply these settings automatically.
        contents = {
          user = {
            name = "Tim Kalan";
            email = "tim.kalan@zerodays.dev";
            signingkey = "~/.ssh/id_ed25519.pub";
          };
        };
      }
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.ghostty = {
    enable = true;
    package = null; # Don't try to install this package (macos thing)
    enableZshIntegration = true;
    settings = {
      font-size = 14;
      font-thicken = true;
      theme = "Gruvbox Dark";
      window-padding-balance = true;

      mouse-hide-while-typing = true;
      copy-on-select = true;
      window-save-state = "always";
      shell-integration = "detect";
      shell-integration-features = "cursor, sudo, title";

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

  programs.lazygit = {
    enable = true;

    settings = {
      # This looks much better on modern terminals
      gui = {
        nerdFontsVersion = "3";
        showIcons = true;
        theme = {
          activeBorderColor = [
            "green"
            "bold"
          ];
          inactiveBorderColor = [ "white" ];
          selectedLineBgColor = [ "reverse" ];
        };
      };

      # Behavior settings
      git = {
        paging = {
          colorArg = "always";
          pager = "${pkgs.delta}/bin/delta --dark --paging=never";
        };
        commit.signOff = true;
      };

      # Disable the startup popup
      update.method = "never";
      notARepository = "quit";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  home.file.".zshrc" = {
    source = ./../.zshrc;
  };
  home.file.".zprofile" = {
    source = ./../.zprofile;
  };
  home.file.".zshenv" = {
    source = ./../.zshenv;
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim";

  home.file.".tmux.conf" = {
    source = ./../.tmux.conf;
  };

  home.file.".scripts/fzf-preview.sh" = {
    source = ./../scripts/fzf-preview.sh;
    executable = true;
  };

  home.file.".scripts/tmux-sessionizer.sh" = {
    source = ./../scripts/tmux-sessionizer.sh;
    executable = true;
  };

}
