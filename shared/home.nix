{
  config,
  pkgs,
  fullName,
  email,
  workEmail,
  ...
}:

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
        name = fullName;
        inherit email;
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
            name = fullName;
            email = workEmail;
            signingkey = "~/.ssh/id_ed25519.pub";
          };
        };
      }
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      syntax-theme = "gruvbox-dark";
      line-numbers = true;
      side-by-side = true;
      navigate = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
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

  programs.opencode = {
    enable = true;
    settings = {
      theme = "gruvbox";
    };
  };

  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "${pkgs.delta}/bin/delta --paging=never --color-only";
          }
        ];
      };
      gui = {
        nerdFontsVersion = "3";
        showIcons = true;
        theme = {
          activeBorderColor = [
            "#fabd2f"
            "bold"
          ]; # gruvbox yellow
          inactiveBorderColor = [ "#665c54" ]; # gruvbox bg3
          selectedLineBgColor = [ "#3c3836" ]; # gruvbox bg1
          optionsTextColor = [ "#83a598" ]; # gruvbox blue
          unstagedChangesColor = [ "#fb4934" ]; # gruvbox red
          defaultFgColor = [ "#ebdbb2" ]; # gruvbox fg
          cherryPickedCommitBgColor = [ "#504945" ]; # gruvbox bg2
          cherryPickedCommitFgColor = [ "#b8bb26" ]; # gruvbox green
        };
      };
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
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };

  programs.zsh = {
    enable = true;
    initContent = builtins.readFile ./../configs/.zshrc;
    profileExtra = builtins.readFile ./../configs/.zprofile;
    envExtra = builtins.readFile ./../configs/.zshenv;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./../configs/.tmux.conf;
  };

  home.file = {
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
