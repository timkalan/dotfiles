# Plan: machine roadmap & parked work

Context (2026-06-10): diego (M1 Pro, 16GB) is currently mixed personal/work; a
more powerful work MacBook is expected to land.

## Target state

- **diego + davor** = pure personal ecosystem.
- **New MacBook (32GB-class)** = work device, scaffolded from this same repo as
  the `dagda` host leaf (nix-darwin, work-only).
- **Discipline rule that makes one-repo viable**: nothing employer-identifying
  ever lands in this repo — no internal hostnames, certs, VPN endpoints, tool
  configs. If work-internal config is ever truly required: separate *private*
  flake that takes this repo as an input. Don't build it until forced.

## Sequencing

1. **2026-06-26**: name chosen — `dagda`. Host leaf scaffolded as **Tier 1**
   (full nix-darwin, mirrors diego), work-only: default git identity is
   `workEmail` everywhere (no `~/projects/work/` split), work-only casks/brews,
   no devon launcher. Gated on the `isWork` arg in `shared/home.nix`, so the
   personal hosts are unchanged. Still provisional — real hardware/MDM/IT policy
   is unknown, so the tier may drop to Tier 2 (standalone home-manager) if
   nix-darwin is forbidden; the `home.nix` ports as-is.
1. **Decision 2026-06-10**: stay native on macOS. devon is the *escape hatch*
   (built — see [`hosts/devon/README.md`](hosts/devon/README.md)), not the
   default architecture: reach for it only if work policy forbids nix-darwin
   (Tier 3), or as a personal Linux sandbox.
1. **Work machine lands**: find out policy *first* (admin rights? MDM
   profile? software approval?), then pick a tier:
   - **Tier 1** — full nix-darwin (likely at a small shop).
   - **Tier 2** — Nix allowed, system management not: standalone
     home-manager. New `homeConfigurations.<user>` flake output wiring
     `shared/home.nix`; port `shared/packages.nix` from
     `environment.systemPackages` to `home.packages`. Ask IT for the
     Determinate installer (signed pkg, MDM docs).
   - **Tier 3** — no Nix: symlink `configs/` by hand (they're plain files —
     zshrc, nvim, tmux survive policy).
   - **Any tier + hypervisor allowed**: devon = full Nix sanctuary on a
     locked-down host (UTM is in the App Store, which helps approval).
1. **2026-06-26**: diego shed work stuff — removed the `~/projects/work/` git
   include, the work brews (heroku, stripe, supabase, infisical) + their taps,
   and the slack/bruno casks + dock entries. Also found work residue in the
   shared shell dotfiles: `GOPRIVATE` (github.com/zerodays, github.com/llamajet)
   in `.zshenv` and the `sd`/`sdp`/`sdw` fzf-cd aliases in `.zshrc` — all dropped
   outright (GOPRIVATE not needed for now; the `sd` family was unused). diego is
   now pure personal. Remaining residual (harmless, shared with dagda): the
   sessionizer's generic `~/projects/work` scan and the aerospace `alt-b`/`alt-s`
   labels. `workEmail` stays in `flake.nix` as dagda's identity source.

## Parked items

- **1Password SSH agent** — landed. One identity (`keys.identity`) lives in
  1Password and is served by the agent on the GUI hosts; devon holds no key and
  borrows diego's agent over `ForwardAgent`. diego + devon verified end-to-end.
  Remaining:
  - **davor**: 1Password → Settings → Developer → "Use the SSH agent", then
    rebuild and verify auth + a signed commit.
  - Once every host is green: remove the old per-machine keys from GitHub;
    optionally shred the now-vestigial on-disk `~/.ssh/id_ed25519`.
  - Add a separate `keys.work` identity now that `dagda` is scaffolded — it
    currently signs with `keys.identity`. Keeps the personal/work key boundary.
- **devon under vfkit — landed (manual cutover).** `utmctl start` *hangs* (it
  drives UTM.app over Apple Events / TCC). Replaced by
  [vfkit](https://github.com/crc-org/vfkit) 0.6.3 driving Virtualization.framework
  directly + [gvproxy](https://github.com/containers/gvisor-tap-vsock) 0.8.9 for
  user-mode net. Verified end-to-end on a CoW clone of devon's disk: headless EFI
  boot (fresh NVRAM → systemd-boot removable-media fallback), Rosetta intact
  (`--device rosetta,mountTag=rosetta` → `/run/rosetta`; `docker --platform linux/amd64 … → x86_64`), `ssh localhost:2223`, forwarded-agent git ssh-signing.
  The feared costs evaporated: EFI booted first try, no binfmt re-wire, the getty
  *does* reach the serial log, and the nixpkgs vfkit binary is already signed with
  `com.apple.security.virtualization`. Shipped: `scripts/devon-vfkit.sh`
  (`start|stop|status|ssh|logs`); persistent disk cloned CoW from UTM at
  `~/.local/share/devon-vfkit/devon.img`; vfkit/gvproxy run as detached daemons
  (`nohup`, SIGHUP ignored, stdio detached) so closing a terminal/tab/Ctrl-C
  can't SIGHUP them into shutting the guest down. Trimmed to bare-min: no
  `migrate`/`DEVON_VFKIT_USER`, `stop` = graceful → `kill -9`.
- **devon vfkit — declarative follow-ups** ("then we talk declarative devon"):
  - ~~Closure-ify: pin `vfkit`/`gvproxy`, ship the launcher as a package~~
    **done** — `scripts/devon-vfkit.nix` (`writeShellApplication`, vfkit/gvproxy as
    `runtimeInputs`, build-time shellcheck); `devon` on PATH via `hosts/diego/home.nix`.
    Killed the per-start `nix build`, the `home.file` copy, and the alias.
  - ~~ssh: replace the dead `devon.local` entry with `Host devon → localhost:2223, ForwardAgent`~~ **done** — `hosts/diego/home.nix`.
  - `boot.kernelParams = [ "console=hvc0" "console=tty0" ]` in `hosts/devon` for a
    full serial break-glass console (interim: `DEVON_VFKIT_GUI=1 devon start`
    opens a GUI window).
  - ~~Update `hosts/devon/README.md`~~ **done** — rewritten vfkit-centric; §1
    from-scratch boot flagged unverified (no ISO on hand to validate).
  - **Retiring UTM (in progress).** `utm` cask removed from
    `hosts/diego/homebrew.nix`; next `darwin-rebuild switch` zaps it → app + the
    21 GB `~/Library/Containers/com.utmapp*` bundle go to **Trash** (recoverable
    until emptied). vfkit's `devon.img` is a separate inode → survives.
  - Optional: launchd agent wrapping `devon start` (if always-up wanted);
    vsock instead of gvproxy (no-IP).
- **devon reproducibility — decided 2026-06-23: NOT building a `nix.linux-builder`.**
  The raw-efi-image path (`system.build.image`/nixos-generators emitted via a
  `nix.linux-builder` VZ VM) is a big lift for marginal payoff on a rarely-used escape
  hatch — dropped. vfkit-devon is built + verified end-to-end, so it ships as-is; the
  hand-installed `devon.img` stays a pet. **If devon ever needs a from-scratch rebuild,
  do it on [nixos-lima](https://github.com/nixos-lima/nixos-lima)**, not a linux-builder:
  `limactl start` the released `github:nixos-lima` image (no host Nix, no builder) →
  in-guest `nixos-rebuild --flake .#devon`. lima replaces both the `devon-vfkit.sh`
  control plane and the manual ISO install (README §1–§2); agent forwarding
  (`ssh.forwardAgent`) and rebuild (build-on-guest, host-mounted flake, no push) come out
  ahead; pet/off semantics survive with a cleaner stop. Costs: young dep (nixos-lima
  v0.2.x, ~7 forks), `users.mutableUsers = true` (lima-init owns the user),
  `SSH_AUTH_SOCK`→1Password wiring (lima runs its own `-F` ssh config, ignores
  `~/.ssh/config`), and adopting the image's grub/by-label boot layout. Pivot wholesale
  only if devon becomes a maintenance drag or a from-scratch stand-up actually blocks —
  don't patch the vfkit path.
- **brew → nixpkgs migration** (all verified available for aarch64-darwin):
  awscli2, heroku, stripe-cli, supabase-cli, infisical, m1ddc, memcached,
  redis, sqlite. Keep `mole` on brew (marked broken in nixpkgs). Tradeoff:
  brew autoUpdate keeps fast-moving CLIs fresher than flake updates.
- **karabiner.json is unversioned** — the esc/ctrl dual-role config dies
  with the machine. Vendor into `configs/karabiner/` via
  `mkOutOfStoreSymlink` (same pattern as lazygit).
- **Neovim plugins to consider** (not currently included):
  - **[flash.nvim](https://github.com/folke/flash.nvim)** — labeled jumps for `/`, `f`, and `t` motions. Makes navigating visible text near-instant.
  - **[diffview.nvim](https://github.com/sindrets/diffview.nvim)** — multi-file diffs and merge conflict resolution. Fills the gap between gitsigns and lazygit.
  - **[nvim-dap](https://github.com/mfussenegger/nvim-dap)** + **[nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)** — in-editor debugger with adapters for Go, Rust, JS/TS, Python.
  - **[neotest](https://github.com/nvim-neotest/neotest)** — run tests from the buffer with inline pass/fail. Has adapters for Go, JS/TS, Rust, Python.
- **Screenshots**: `system.defaults.screencapture.location` +
  home-manager-managed `.keep` file so the directory exists on a fresh Mac
  (macOS silently falls back to Desktop if it's missing).
- **Homebrew breakage — resolved declaratively** (brew's 2026 security push:
  `--cleanup` deprecation + `HOMEBREW_REQUIRE_TAP_TRUST`). Fixed by
  [nix-darwin#1789](https://github.com/nix-darwin/nix-darwin/pull/1789) (merged
  2026-06-18; backported to `nix-darwin-26.05` in #1805). nix-darwin pin bumped
  past it (2026-06-07 → 2026-06-18). `hosts/diego/homebrew.nix` now maps the
  non-official taps to `{ trusted = true; }` — nix-darwin emits short cask/brew
  names, so trust must sit on the *tap*, not the entry — and nix-darwin emits
  `--force-cleanup` itself, so the manual `extraFlags = [ "--force-cleanup" ]`
  is gone. Why the imperative `brew trust` (2026-06-10) never took: brew picks
  its trust file by `$XDG_CONFIG_HOME` (zshenv → `~/.config/homebrew/trust.json`),
  but activation strips env (`sudo --preserve-env=PATH`) so *its* brew reads
  `~/.homebrew/trust.json`. The declarative `trusted: true` sidesteps this —
  `brew bundle` asserts trust inline each run; the stale
  `~/.config/homebrew/trust.json` is now vestigial.
- **Watch: [apple/container](https://github.com/apple/container)** (1.0.0
  on 2026-06-09) — per-container lightweight VMs, OCI-compliant, Apache-2.0
  (no Docker Desktop corp-license problem). Not adoptable yet: no Docker
  daemon API / first-party compose, so `supabase start`-style workflows
  don't work (community shims: mocker, Container-Compose), and it requires
  macOS 26 Tahoe (diego is on 15 Sequoia). Re-evaluate as docker-desktop
  replacement once on Tahoe *and* the Docker-API compat story matures.
  Its **`container machine`** feature (persistent Linux env, real init,
  host $HOME auto-mounted) targets devon's use case with zero GUI — but
  machines are mutable OCI images (Ubuntu/Alpine), no NixOS path, so it
  doesn't replace devon-as-specced. Two future plays: (a) work-machine
  Tier 2.5 — Ubuntu machine + nix + standalone home-manager inside, using
  only Apple-signed tooling (easiest IT approval); (b) if a
  NixOS-closure-as-OCI-init image recipe matures, revisit devon-on-machine.
  Note the $HOME mount is virtiofs — keep heavy repos on the machine disk.
