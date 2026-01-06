{ inputs, username, ... }:
{
  imports = [
    ./homebrew.nix
    ../../shared
    inputs.home-manager.darwinModules.home-manager
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
    options = "--delete-older-than 30d";
  };

  # Optimize storage (hard-link duplicates)
  nix.optimise.automatic = true;

  # Machine-specific unique ID
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # macOS Specifics
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.defaults = {
    dock = {
      autohide = true;
      autohide-time-modifier = 0.1;
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
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
    trackpad.Clicking = true;
  };

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # "backup" creates .backup files if there is a conflict
    backupFileExtension = "backup";

    users.${username} = {
      imports = [
        ../../shared/home.nix
      ];
    };
  };
}
