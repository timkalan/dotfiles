{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    tmux
    git
    wget
    curl

    ripgrep
    fd
    bat
    eza
    fzf
    zoxide
    starship
    direnv
    jq
    tldr
    tree
    tokei
    hyperfine
    fastfetch
    stow

    gh
    lazygit
    lazydocker

    go
    golangci-lint
    nodejs_24
    deno
    python3
    lua
    luajit
    cmake
    gnumake
    nixfmt
    postgresql

    ffmpeg
    imagemagick

    slides
  ];
}
