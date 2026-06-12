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
  };

  networking.hostName = "devon";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };

    # Resolvable as devon.local from the host (UTM DHCP leases drift)
    avahi = {
      enable = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };

    # Return deleted blocks to the host's sparse disk image
    fstrim.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };

    # x86_64 binaries via Rosetta.
    # Requires UTM engine "Apple Virtualization" with "Enable Rosetta" ticked.
    rosetta.enable = true;
  };

  users = {
    users.${username} = {
      isNormalUser = true;
      description = fullName;
      extraGroups = [
        "wheel"
        "docker"
      ];
      openssh.authorizedKeys.keys = [ keys.diego ];
      useDefaultShell = true;
    };

    defaultUserShell = pkgs.zsh;
  };

  # The SSH key is the auth boundary; VM console access implies host access.
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "26.11";
}
