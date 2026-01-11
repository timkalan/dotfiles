{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # basic tools
    neovim
    tmux
    git
    wget
    curl

    # fancy tools
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

    # devops
    gh
    lazygit
    lazydocker

    # languages
    go
    nodejs_24
    deno
    bun
    python3
    lua
    luajit
    cmake
    gnumake
    postgresql

    # language tools
    bash-language-server
    clang-tools
    gopls
    golangci-lint
    lua-language-server
    pyright
    ruff
    rust-analyzer
    tailwindcss-language-server
    vscode-langservers-extracted
    vtsls
    yaml-language-server
    nil

    biome
    black
    isort
    nixfmt
    shfmt
    stylua

    # media
    ffmpeg
    imagemagick

    # other
    slides
    opencode
  ];
}
