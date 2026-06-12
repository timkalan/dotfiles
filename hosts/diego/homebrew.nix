_: {
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      # brew >=4.5 (2026-05-24) requires force for non-interactive cleanup;
      # drop once nix-darwin#1789 lands.
      extraFlags = [ "--force-cleanup" ];
      autoUpdate = true;
      upgrade = true;
    };

    casks = [
      "1password"
      "aerospace"
      "betterdisplay"
      "bruno"
      "docker-desktop"
      "ghostty"
      "google-chrome"
      "helium-browser"
      "karabiner-elements"
      "obsidian"
      "raycast"
      "slack"
      "tailscale-app"
      "the-unarchiver"
      "utm"
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

    taps = [
      "heroku/brew"
      "supabase/tap"
      "infisical/get-cli"
      "nikitabobko/tap"
      "stripe/stripe-cli"
      "darrylmorley/whatcable"
    ];
  };
}
