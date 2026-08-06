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
`let` block to make it your own. `workEmail` is a placeholder — set the real
value for the work host locally.

## Per-machine manual setup (macOS)

macOS gates these behind interactive auth or Control Center state, so they can't
come from the flake. Do them once on a fresh darwin host (diego/dagda):

- [ ] Sign in to Apple ID (System Settings).
- [ ] Enroll a Touch ID fingerprint (sudo Touch ID is already wired in nix).
- [ ] Log out and back in once to apply the English UI language.
- [ ] Kickstart Karabiner after the first rebuild — the config is a nix-store
  symlink its file-watcher can't follow:
  `launchctl kickstart -k "gui/$(id -u)/org.pqrs.service.agent.Karabiner-Core-Service-rev2"`
- [ ] Hide the Spotlight menu bar icon: Control Center → Spotlight →
  "Don't Show in Menu Bar".
- [ ] Set default browser to Zen: System Settings → Desktop & Dock.
- [ ] Raycast onboarding → set `⌘Space` (takes over the Spotlight shortcut).
- [ ] Optional: enable iCloud Desktop & Documents (Apple ID → iCloud → Drive).

Menu bar and dock changes from a `rebuild` need a logout (or
`killall SystemUIServer ControlCenter Dock`) to redraw.

## Future work

- Separate `keys.work` SSH identity for the work host (dagda) so work git
  signing is distinct from the personal `keys.identity`.
- Declarative screenshot location: `system.defaults.screencapture.location`
  plus a home-manager-managed `.keep` so the directory exists on a fresh Mac.
- davor: enable the 1Password SSH agent, then rebuild and verify auth + a
  signed commit.
- Optional: migrate slow-moving CLIs from Homebrew to nixpkgs; evaluate nvim
  plugins (flash, diffview, nvim-dap, neotest).
