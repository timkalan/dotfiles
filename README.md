# dotfiles

Nix flake configuration for my machines.

## Hosts

- **diego** - macOS (darwin), personal
- **dagda** - macOS (darwin), work
- **davor** - NixOS (x86_64-linux)
- **devon** - NixOS (aarch64-linux), headless vfkit guest on darwin

## Usage

```bash
# macOS
darwin-rebuild switch --flake .

# NixOS
sudo nixos-rebuild switch --flake .
```

## Structure

```
flake.nix          # Entry point
hosts/             # Host-specific configs
shared/            # Shared modules (home-manager, packages)
configs/           # Dotfiles (nvim, zsh, tmux, etc.)
```

## Personalization

All personal data (name, email, SSH keys) is defined in `flake.nix`. Update the
`let` block to make it your own.
