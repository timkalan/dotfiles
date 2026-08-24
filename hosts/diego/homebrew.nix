_: {
  homebrew = {

    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    casks = [
      "1password"
      "aerospace"
      "betterdisplay"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "obsidian"
      "raycast"
      "tailscale-app"
      "the-unarchiver"
      "zen"
      "whatcable"
    ];

    brews = [
      "m1ddc"
      "mole"
    ];

    # Non-official taps: brew >=6.0 (HOMEBREW_REQUIRE_TAP_TRUST) refuses to load
    # their formulae/casks unless the tap is trusted. nix-darwin emits short
    # names, so trust must come from the tap, not per-cask/brew (nix-darwin#1789).
    taps =
      map
        (name: {
          inherit name;
          trusted = true;
        })
        [
          "nikitabobko/tap"
          "darrylmorley/whatcable"
        ];
  };
}
