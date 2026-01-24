{ self, ... }:
{
  imports = [
    ./packages.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Optimize storage (hard-link duplicates)
  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;

  time.timeZone = "Europe/Ljubljana";
}
