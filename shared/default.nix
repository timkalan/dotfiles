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

  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;

  time.timeZone = "Europe/Ljubljana";
}
