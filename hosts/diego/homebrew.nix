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
      "bruno"
      "ghostty"
      "google-chrome"
      "helium-browser"
      "karabiner-elements"
      "obsidian"
      "raycast"
      "slack"
      "tailscale-app"
      "the-unarchiver"
      "zen"
      "whatcable"
    ];

    brews = [
      "awscli"
      "heroku"
      "infisical"
      "m1ddc"
      "memcached"
      "mole"
      "redis"
      "sqlite"
      "stripe"
      "supabase"
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
          "heroku/brew"
          "supabase/tap"
          "infisical/get-cli"
          "nikitabobko/tap"
          "stripe/stripe-cli"
          "darrylmorley/whatcable"
        ];
  };
}
