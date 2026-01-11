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
    direnv
    jq
    tldr
    tree
    tokei
    hyperfine
    fastfetch

    gh
    lazygit
    lazydocker

    go
    golangci-lint
    nodejs_24
    deno
    bun
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
    opencode
  ];
}
