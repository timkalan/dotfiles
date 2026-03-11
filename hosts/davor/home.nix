{ pkgs, config, ... }:

let
  colors = import ./colors.nix;
in

{
  imports = [
    ../../shared/home.nix
  ];

  # Wallpaper (used by swaybg and hyprlock)
  home.file."Pictures/Wallpapers/wallpaper.jpg".source = ./wallpapers/wallpaper.jpg;

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
      brave

      # Games
      heroic

      # Utils
      jq
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = import ./hyprland/default.nix { inherit colors; };
  };

  programs.waybar = import ./waybar.nix { inherit colors; };

  programs.wofi = import ./wofi.nix { inherit colors; };

  services.mako = import ./mako.nix { inherit colors; };

  programs.hyprlock = import ./hyprlock.nix { inherit colors; };

  services.hypridle = import ./hypridle.nix;

  programs.ghostty = {
    settings = {
      font-size = 12;
      background-opacity = 0.95;
      confirm-close-surface = false;
      keybind = [
        "performable:ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
      ];
    };
  };

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

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  programs.zsh = {
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/#davor";
    };
  };

  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "wl-copy"
  '';

  home.file.".scripts/toggle-projector.sh" = {
    source = ../../scripts/toggle-projector.sh;
    executable = true;
  };

  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = wofi --dmenu -i -p "WiFi"

    [editor]
    terminal = ghostty
  '';

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
