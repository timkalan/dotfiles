{ config, pkgs, ... }:

{
  # The version of Home Manager you are using.
  home.stateVersion = "25.11";

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    cowsay
    # fortune
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

  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo darwin-rebuild switch --flake ~/dotfiles/";
      lg = "lazygit";
      ls = "eza -lahF --git --icons";
      cl = "clear";
      tree = "tree -C";
      ".." = "cd ..";
      vi = "nvim";
      vim = "nvim";
    };

    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
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

    initContent = ''
      # --- Options ---
      setopt BANG_HIST
      setopt EXTENDED_HISTORY
      setopt INC_APPEND_HISTORY
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_VERIFY

      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt CORRECT
      setopt GLOB_DOTS
      setopt NUMERIC_GLOB_SORT
      setopt RC_EXPAND_PARAM
      unsetopt BEEP

      setopt AUTO_LIST
      setopt AUTO_MENU
      setopt COMPLETE_IN_WORD
      setopt ALWAYS_TO_END

      # --- FZF Integration ---
      export FZF_DEFAULT_OPTS="--preview '$HOME/.scripts/fzf-preview.sh {}'"
      bindkey '^g' fzf-cd-widget

      # --- NVM & Mise (Lazy Load) ---
      # Kept for compatibility, though usually replaced by 'direnv' in NixOS
      export NVM_DIR="$HOME/.nvm"
      nvm() {
        unset -f nvm
        [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
        nvm "$@"
      }

      if [ -f ~/.local/bin/mise ]; then
        eval "$(~/.local/bin/mise activate zsh)"
      fi

      # --- Tmux Sessionizer ---
      tmux_sessionizer_widget() {
        zle reset-prompt
        tmux-sessionizer.sh
      }
      zle -N tmux_sessionizer_widget
      bindkey -M viins '^F' tmux_sessionizer_widget
      bindkey -M vicmd '^F' tmux_sessionizer_widget

      eval "$(shai --zsh-init)"
    '';
  };

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GOPRIVATE = "github.com/zerodays,github.com/llamajet";
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "$HOME/.config";
    PNPM_HOME = "${config.home.homeDirectory}/Library/pnpm";
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

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim";

  home.file.".scripts/fzf-preview.sh" = {
    source = ./../scripts/fzf-preview.sh;
    executable = true;
  };

  home.file.".scripts/tmux-sessionizer.sh" = {
    source = ./../scripts/tmux-sessionizer.sh;
    executable = true;
  };

}
