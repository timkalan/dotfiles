{ self, lib, ... }:
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

  # tmux 3.7's configure aborts on darwin unless it is told explicitly whether
  # to use jemalloc, and our nixpkgs pin passes neither flag. Already fixed
  # upstream, so drop this on the next nixpkgs bump.
  nixpkgs.overlays = [
    (final: prev:
      lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
        tmux = prev.tmux.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ final.jemalloc ];
          configureFlags = old.configureFlags ++ [ "--enable-jemalloc" ];
        });
      }
    )
  ];
  programs.zsh.enable = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;

  time.timeZone = "Europe/Ljubljana";
}
