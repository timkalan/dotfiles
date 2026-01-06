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
      "zen"
    ];

    brews = [
      "awscli"
      "heroku"
      "infisical"
      "memcached"
      "opencode"
      "redis"
      "sqlite"
      "stripe"
      "supabase"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "zsh-vi-mode"

      # megabon
      "pixman"
      "cairo"
      "pango"
      "jpeg-turbo"
      "giflib"
    ];

    taps = [
      "heroku/brew"
      "supabase/tap"
      "infisical/get-cli"
      "nikitabobko/tap"
      "stripe/stripe-cli"
    ];
  };
}
