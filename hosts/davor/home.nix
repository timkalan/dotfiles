{ pkgs, config, ... }:

let
  colors = import ./colors.nix;
in

{
  imports = [
    ../../shared/home.nix
    ./hyprpaper.nix
  ];

  home = {
    sessionVariables = {
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };
    sessionPath = [ "$HOME/.local/share/pnpm" ];
    packages = with pkgs; [
      # Monitoring
      iotop
      iftop
      strace
      ltrace
      lsof

      # Wayland / Hyprland ecosystem
      wl-clipboard
      wl-clip-persist
      clipse
      waybar
      wofi
      swaybg
      hyprshot
      hyprpicker
      hyprlock
      hypridle
      mako
      networkmanager_dmenu
      playerctl
      brightnessctl

      # Desktop apps
      nautilus
      pavucontrol
      bluetuith
      obsidian

      # Games
      heroic

      # Utils
      jq
    ];
  };

  # ── Hyprland ────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    settings = import ./hyprland/default.nix { inherit colors; };
  };

  # ── Waybar ──────────────────────────────────────────────
  programs.waybar = import ./waybar.nix { inherit colors; };

  # ── Wofi ────────────────────────────────────────────────
  programs.wofi = import ./wofi.nix { inherit colors; };

  # ── Mako (notifications) ────────────────────────────────
  services.mako = import ./mako.nix { inherit colors; };

  # ── Hyprlock (lock screen) ──────────────────────────────
  programs.hyprlock = import ./hyprlock.nix { inherit colors; };

  # ── Hypridle (idle management) ──────────────────────────
  services.hypridle = import ./hypridle.nix { inherit colors; };

  # ── Ghostty ─────────────────────────────────────────────
  programs.ghostty = {
    settings = {
      font-size = 12;
      background-opacity = 0.95;
      keybind = [
        "performable:ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
      ];
    };
  };

  # ── Btop ───────────────────────────────────────────────
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      theme_background = false;
      rounded_corners = false;
      truecolor = true;
      vim_keys = true;
      update_ms = 2000;
      proc_sorting = "cpu lazy";
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = false;
      show_uptime = true;
      check_temp = true;
      show_coretemp = true;
      temp_scale = "celsius";
      show_cpu_freq = true;
      show_battery = false;
      graph_symbol = "braille";
      clock_format = "%H:%M";
    };
  };

  # ── GTK theming ─────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      size = 24;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # ── Cursor ──────────────────────────────────────────────
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };

  # ── Zsh ─────────────────────────────────────────────────
  programs.zsh = {
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/#davor";
    };
  };

  # ── Tmux ────────────────────────────────────────────────
  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "wl-copy"
  '';

  # ── Scripts ─────────────────────────────────────────────
  home.file.".scripts/toggle-projector.sh" = {
    source = ../../scripts/toggle-projector.sh;
    executable = true;
  };

  # ── networkmanager_dmenu config ────────────────────────
  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = wofi --dmenu -i -p "WiFi"

    [editor]
    terminal = ghostty
  '';

  # ── Firefox ─────────────────────────────────────────────
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        # Theme
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;

        # New tab
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # Disable bloat
        "extensions.pocket.enabled" = false;
        "browser.tabs.firefox-view" = false;
        "browser.tabs.firefox-view-next" = false;
        "browser.ml.chat.enabled" = false;
        "browser.promo.focus.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;

        # Privacy & Security
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.contentblocking.category" = "strict";
        "browser.sessionstore.restore_on_demand" = true;
        "browser.sessionstore.restore_pinned_tabs_on_demand" = true;

        # UX
        "browser.download.useDownloadDir" = false;
        "general.smoothScroll" = true;
        "accessibility.browsewithcaret" = false;
        "browser.toolbars.bookmarks.visibility" = "never";

        # Disable annoyances
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.showMobileBookmarks" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.searches" = false;
      };
    };
  };
}
