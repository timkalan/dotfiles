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
    delta

    # devops
    gh
    lazygit
    lazydocker

    # languages
    lua
    luajit

    # build tools
    cmake
    gcc
    gnumake
    postgresql

    # language tools
    bash-language-server
    lua-language-server
    marksman
    nil
    taplo
    yaml-language-server

    # linters and formatters
    actionlint
    hadolint
    markdownlint-cli
    mdformat
    nixfmt
    shellcheck
    shfmt
    statix
    stylua
    tree-sitter
    typos
    yamllint

    # docker tools
    docker-compose-language-service
    dockerfile-language-server

    # media
    ffmpeg
    imagemagick

    # other
    slides
    opencode
    claude-code
  ];
}
