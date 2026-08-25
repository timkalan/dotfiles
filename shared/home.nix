{
  config,
  pkgs,
  inputs,
  fullName,
  email,
  workEmail,
  keys,
  ...
}@args:

let
  isWork = args.isWork or false;

  herdrPackage = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # One source of truth for the plugin's identity: the manifest herdr reads and
  # the registry entry that points at it are both generated from this.
  sessionizer = rec {
    id = "sessionizer";
    name = "Sessionizer";
    version = "0.1.0";
    minHerdrVersion = "0.8.0";
    root = "${config.home.homeDirectory}/.config/herdr/plugins/${id}";
  };

  # A manifest command is argv with no shell or env expansion, so every program
  # it names has to be an absolute path. Building the scripts here pins their
  # tools too, which matters because plugin commands inherit herdr's own PATH —
  # and a GUI-launched herdr on macOS has almost nothing on it.
  pluginScript =
    name: runtimeInputs:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = builtins.readFile (./../configs/herdr/plugins/sessionizer + "/${name}.sh");
      # SC2016: jq programs are single-quoted on purpose. SC1010: `--sound done`
      # is a herdr argument, not a loop terminator.
      excludeShellChecks = [
        "SC1010"
        "SC2016"
      ];
    };

  sessionizerScript = pluginScript "sessionizer" (
    with pkgs;
    [
      jq
      git
      fd
      fzf
      # reached indirectly through ~/.scripts/fzf-preview.sh
      bat
      eza
      # only for a run from the CLI; as a plugin it uses HERDR_BIN_PATH
      herdrPackage
    ]
  );
  bootstrapScript = pluginScript "bootstrap" [ pkgs.jq ];
  worktreeCleanupScript = pluginScript "worktree-cleanup" (
    with pkgs;
    [
      jq
      git
    ]
  );

  sessionizerManifest = (pkgs.formats.toml { }).generate "herdr-plugin.toml" {
    inherit (sessionizer) id name version;
    min_herdr_version = sessionizer.minHerdrVersion;
    description = "Fuzzy-find a project directory and open it as a workspace";
    # Omitting this reads as "support unknown" and herdr warns; the hosts this
    # repo builds are the two platforms it is actually tested on.
    platforms = [
      "linux"
      "macos"
    ];

    panes = [
      {
        id = "picker";
        title = "Sessionizer";
        placement = "popup";
        command = [ (pkgs.lib.getExe sessionizerScript) ];
        width = "80%";
        height = "55%";
      }
    ];

    actions = [
      {
        id = "pick";
        title = "Sessionizer";
        contexts = [ "global" ];
        command = [
          "${herdrPackage}/bin/herdr"
          "plugin"
          "pane"
          "open"
          "--plugin"
          sessionizer.id
          "--entrypoint"
          "picker"
        ];
      }
      {
        id = "worktree-cleanup";
        title = "Remove worktree and branch";
        contexts = [ "workspace" ];
        command = [ (pkgs.lib.getExe worktreeCleanupScript) ];
      }
    ];

    events = [
      {
        on = "workspace.created";
        command = [ (pkgs.lib.getExe bootstrapScript) ];
      }
    ];
  };

  gruvbox-truecolor = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "gruvbox-truecolor";
    version = "unstable-bcc1d78";
    rtpFilePath = "colorscheme-tpm.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "lawabidingcactus";
      repo = "tmux-gruvbox-truecolor";
      rev = "bcc1d78310c94de59be860f3d5ec277878e34e73";
      hash = "sha256-0ERXKX3RjsJTTHCe2x0ZtvSuXRxaU7x9C+IpqKlKnCE=";
    };
  };
in
{
  home = {
    # The version of Home Manager you are using.
    stateVersion = "25.11";
    packages = with pkgs; [
      nodejs
      starship
      inputs.llm-agents.packages.${stdenv.hostPlatform.system}.omp
    ];
  };

  programs = {
    # Let Home Manager manage itself.
    home-manager.enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config.local" ];
  };

  programs.git = {
    enable = true;

    signing = {
      key = keys.identity;
      signByDefault = true;
    };

    settings = {
      user = {
        name = fullName;
        email = if isWork then workEmail else email;
      };
      gpg.format = "ssh";
      push.autoSetupRemote = true;

      url."git@github.com:".insteadOf = "https://github.com/";
    };

    ignores = [
      ".DS_Store"
      ".env"
      ".envrc"
      ".direnv"
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
    withRuby = false;
    withPython3 = false;
    sideloadInitLua = true;
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
    tui = {
      theme = "gruvbox";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      theme_background = false;
      rounded_corners = false;
      vim_keys = true;
      clock_format = "%H:%M";
    };
  };

  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        diffRenderers = [
          {
            colorArg = "always";
            command = "${pkgs.delta}/bin/delta --paging=never --color-only";
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

  programs.worktrunk = {
    enable = true;
    enableZshIntegration = true;
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
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
  };

  programs.tmux = {
    enable = true;
    plugins = [
      gruvbox-truecolor
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
      }
      {
        plugin = pkgs.tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = builtins.readFile ./../configs/.tmux.conf;
  };

  programs.herdr = {
    enable = true;
    package = herdrPackage;

    # Only settings that differ from herdr's defaults.
    settings = {
      onboarding = false;

      keys = {
        prefix = "ctrl+space";
        open_worktree = "prefix+shift+o";
        remove_worktree = "prefix+shift+e";
        command = [
          {
            key = "prefix+f";
            type = "plugin_action";
            command = "${sessionizer.id}.pick";
            description = "sessionizer";
          }
          {
            key = "ctrl+f";
            type = "plugin_action";
            command = "${sessionizer.id}.pick";
            description = "sessionizer";
          }
        ];
      };
      theme.name = "gruvbox";
      ui = {
        sidebar_collapsed_mode = "hidden";
        show_agent_labels_on_pane_borders = true;
        toast = {
          delivery = "herdr";
        };
      };
    };
  };

  programs.claude-code = {
    enable = true;

    context = ./../configs/CLAUDE.md;
    skills = ./../configs/skills;

    settings = {
      model = "opus";
      tui = "fullscreen";
      editorMode = "vim";
      outputStyle = "Concise";
      autoMemoryEnabled = false;
      enabledPlugins = {
        "gopls-lsp@claude-plugins-official" = true;
      };
    };
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

  xdg = {
    configFile = {
      "nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/nvim";

      "herdr/plugins/${sessionizer.id}/herdr-plugin.toml".source = sessionizerManifest;

      # herdr rewrites plugins.json on plugin link/unlink/enable/disable, which
      # would replace this symlink with a real file and break the next switch.
      # Registering the plugin here instead means never running those commands.
      "herdr/plugins.json".text = builtins.toJSON [
        {
          plugin_id = sessionizer.id;
          inherit (sessionizer) name version;
          min_herdr_version = sessionizer.minHerdrVersion;
          manifest_path = "${sessionizer.root}/herdr-plugin.toml";
          plugin_root = sessionizer.root;
          enabled = true;
          source.kind = "local";
        }
      ];

      "worktrunk/config.toml".text = ''
        worktree-path = "{{ repo_path }}/../{{ repo }}_{{ branch | sanitize }}"
        post-switch = "~/.scripts/tmux-sessionizer.sh {{ worktree_path }}"
        post-remove = "tmux switch-client -t {{ repo }} 2>/dev/null; tmux kill-session -t {{ repo }}_{{ branch | sanitize }} 2>/dev/null || true"

        [switch]
        cd = false
      '';

      "sqlfluff/.sqlfluff".text = ''
        [sqlfluff]
        dialect = postgres
        exclude_rules = LT12, LT01, LT02, LT09
        max_line_length = 120
      '';
    };
  };
}
