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
    # Binary cache for llm-agents.nix (omp et al.), built daily by Numtide.
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  # Optimize storage (hard-link duplicates)
  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;

  time.timeZone = "Europe/Ljubljana";
}
