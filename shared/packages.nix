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
    btop

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
    cargo
    cmake
    gcc
    gnumake
    postgresql

    # language tools
    bash-language-server
    clang-tools
    docker-compose-language-service
    dockerfile-language-server
    gofumpt
    gopls
    golangci-lint
    golangci-lint-langserver
    lua-language-server
    marksman
    pyright
    ruff
    rust-analyzer
    tailwindcss-language-server
    taplo
    vscode-langservers-extracted
    vtsls
    yaml-language-server
    nil

    actionlint
    biome
    black
    hadolint
    isort
    markdownlint-cli
    nixfmt
    prettierd
    shellcheck
    shfmt
    statix
    stylua
    tree-sitter
    typos
    rustywind
    yamllint

    protobuf
    protoc-gen-go

    # media
    ffmpeg
    imagemagick

    # other
    slides
    opencode
    claude-code
  ];
}
