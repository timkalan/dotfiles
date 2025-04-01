# dotfiles

This repo contains all the dotfiles to set up my development experience on a new machine.

## Installation

Clone this repository from your home folder, so you get a `~/dotfiles/` folder. `cd` into it and run

```bash
stow .
```

To create the symlinks from this folder to the home folder.

## Nix

Installed via the [Determinate installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#features)
(which also provides an uninstall script, can survive macOS upgrades, ...)

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

Nix can be updated via

```bash
sudo -i nix upgrade-nix
```

and uninstalled via

```bash
/nix/nix-installer uninstall
```

### Nix commands

One off packages can be run with

```bash
nix run nixpkgs#PACKAGE -- -FLAG ARG
```

### Nix Darwin

Can be used to manage macOS using nix. Look in `nix/flake.nix` for the configuration. To install it, run

```bash
nix run nix-darwin/master#darwin-rebuild -- switch
```

After installation, apply changes using

```bash
darwin-rebuild switch
```

## Tools
- `aerospace` (window manager)
- `ghostty` (terminal)
- `wezterm` (terminal)
- `zsh` (shell)
- `tmux` (terminal multiplexer)
- `neovim` (editor)

## Requirements (wip)
- `homebrew` (package manager)
- `fzf` (fuzzy finder)
- `stow`
