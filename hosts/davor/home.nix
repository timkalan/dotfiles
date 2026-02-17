{ pkgs, ... }:

{
  imports = [
    ../../shared/home.nix
  ];

  home = {
    sessionVariables = {
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };
    sessionPath = [ "$HOME/.local/share/pnpm" ];
    packages = with pkgs; [
      # Monitoring (Linux specific tools)
      iotop

      wl-clipboard
      iftop
      strace
      ltrace
      lsof

      # Games
      heroic

      # Hyprland Ecosystem
      waybar
      dunst
      wofi
      hyprpaper
      kitty
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Q, exec, ghostty"
        "$mod, M, exit"
        "$mod, space, exec, wofi --show drun"
      ];
    };
  };

  programs.wofi = import ./wofi.nix { inherit pkgs; };
  programs.waybar = import ./waybar.nix { inherit pkgs; };

  programs.ghostty = {
    settings = {
      font-size = 12;
    };
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  programs.zsh = {
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/#davor";
    };
  };

  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "wl-copy"
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

        # New tab - show top sites but no stories/sponsored content
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

        # Privacy & Security (balanced)
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.contentblocking.category" = "strict";
        "browser.sessionstore.restore_on_demand" = true;
        "browser.sessionstore.restore_pinned_tabs_on_demand" = true;

        # UX improvements
        "browser.download.useDownloadDir" = false;
        "general.smoothScroll" = true;
        "accessibility.browsewithcaret" = false;

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
