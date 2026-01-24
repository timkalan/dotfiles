{
  inputs,
  username,
  fullName,
  email,
  workEmail,
  ...
}:
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
    options = "--delete-older-than 7d";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system = {
    # Machine-specific unique ID
    stateVersion = 6;
    # macOS Specifics
    primaryUser = username;

    defaults = {
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
  };

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        username
        fullName
        email
        workEmail
        inputs
        ;
    };

    # "backup" creates .backup files if there is a conflict
    backupFileExtension = "backup";

    users.${username} = {
      imports = [
        ./home.nix
      ];
    };
  };
}
