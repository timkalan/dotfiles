{
  pkgs,
  username,
  fullName,
  keys,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices."luks-c792f8d3-e1ff-4c14-9e85-3a7210967788".device =
      "/dev/disk/by-uuid/c792f8d3-e1ff-4c14-9e85-3a7210967788";
  };

  networking = {
    hostName = "davor";
    networkmanager.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "sl_SI.UTF-8";
      LC_IDENTIFICATION = "sl_SI.UTF-8";
      LC_MEASUREMENT = "sl_SI.UTF-8";
      LC_MONETARY = "sl_SI.UTF-8";
      LC_NAME = "sl_SI.UTF-8";
      LC_NUMERIC = "sl_SI.UTF-8";
      LC_PAPER = "sl_SI.UTF-8";
      LC_TELEPHONE = "sl_SI.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Clean TTY for greetd
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Auto-login to Hyprland, hyprlock locks immediately on boot
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
          user = "${username}";
        };
      };
    };

    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    printing.enable = true;

    # Secret Service provider (for gh, etc.)
    gnome.gnome-keyring.enable = true;

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };

    firefox.enable = true;
    steam.enable = true;
    gamemode.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ username ];
    };
  };

  users = {
    users.${username} = {
      isNormalUser = true;
      description = fullName;
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
      openssh.authorizedKeys.keys = [ keys.diego ];
      useDefaultShell = true;
    };

    defaultUserShell = pkgs.zsh;
  };

  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  system.stateVersion = "25.11";

}
