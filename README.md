# dotfiles

Nix flake configuration for my machines.

## Hosts

- **diego** - macOS (darwin)
- **davor** - NixOS (x86_64-linux)

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

## Neovim: Optional Improvements

Plugins worth considering that aren't currently included:

- **[flash.nvim](https://github.com/folke/flash.nvim)** — labeled jumps for `/`, `f`, and `t` motions. Makes navigating visible text near-instant.
- **[diffview.nvim](https://github.com/sindrets/diffview.nvim)** — multi-file diffs and merge conflict resolution. Fills the gap between gitsigns and lazygit.
- **[nvim-dap](https://github.com/mfussenegger/nvim-dap)** + **[nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)** — in-editor debugger with adapters for Go, Rust, JS/TS, Python.
- **[neotest](https://github.com/nvim-neotest/neotest)** — run tests from the buffer with inline pass/fail. Has adapters for Go, JS/TS, Rust, Python.
