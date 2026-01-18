{ config, pkgs, ... }:

{
  home = {
    # The version of Home Manager you are using.
    stateVersion = "25.11";
    packages = with pkgs; [
      starship
    ];
  };

  programs = {
    # Let Home Manager manage itself.
    home-manager.enable = true;
  };

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
      ".envrc"
      ".direnv"
      ".direnv/"
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file = {
    ".zshrc" = {
      source = ./../configs/.zshrc;
    };
    ".zprofile" = {
      source = ./../configs/.zprofile;
    };
    ".zshenv" = {
      source = ./../configs/.zshenv;
    };
    ".tmux.conf" = {
      source = ./../configs/.tmux.conf;
    };
    ".scripts/fzf-preview.sh" = {
      source = ./../scripts/fzf-preview.sh;
      executable = true;
    };
    ".scripts/tmux-sessionizer.sh" = {
      source = ./../scripts/tmux-sessionizer.sh;
      executable = true;
    };
  };

  xdg.configFile = {
    "nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/nvim";
  };

}
