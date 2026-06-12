{
  username,
  ...
}:
{
  imports = [
    ./homebrew.nix
    ../../shared
  ];

  # Free some storage space
  nix.gc = {
    automatic = true;
    # Run every Sunday at 2:00 AM
    interval = {
      Weekday = 0;
      Hour = 2;
      Minute = 0;
    };
    options = "--delete-older-than 7d";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  networking = {
    computerName = "diego";
    hostName = "diego";
    localHostName = "diego";

    applicationFirewall = {
      enable = true;
      enableStealthMode = true;
    };
  };

  system = {
    # Machine-specific unique ID
    stateVersion = 6;
    # macOS Specifics
    primaryUser = username;

    defaults = {
      controlcenter.BatteryShowPercentage = true;
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.1;
        expose-group-apps = true;
        mru-spaces = false;
        orientation = "right";
        persistent-apps = [
          "/Applications/Ghostty.app/"
          "/Applications/Zen.app/"
          "/Applications/Slack.app/"
          "/Applications/Obsidian.app/"
          "/Applications/Bruno.app/"
          "/Applications/1Password.app/"
          "/System/Applications/Mail.app/"
          "/System/Applications/Music.app/"
          "/System/Applications/System Settings.app/"
        ];
        persistent-others = [
          "/Users/${username}/Downloads"
        ];
        show-recents = false;
        # 14 = Quick Note
        wvous-br-corner = 14;
      };
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
        NewWindowTarget = "Recents";
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      loginwindow.GuestEnabled = false;
      menuExtraClock.ShowSeconds = true;
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      trackpad.Clicking = true;
      WindowManager.EnableStandardClickToShowDesktop = false;
    };
  };

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
  };

}
