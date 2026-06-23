# devon — headless NixOS dev VM

A headless NixOS guest on Apple Virtualization (run via vfkit), reached over
`ssh`. A real Linux dev box on the Mac — Docker, x86 binaries via Rosetta, the
full dotfiles stack — while the macOS host stays a thin layer. devon is
disposable: everything but uncommitted code is rebuildable from this repo.

Config: `hosts/devon/{default,home,hardware-configuration}.nix` and
`nixosConfigurations."devon"` in `flake.nix`. It runs under vfkit + gvproxy
(Apple's Virtualization.framework — no app, no daemon) via
the `devon` command (`scripts/devon-vfkit.{nix,sh}`); the guest's sshd is reachable at `localhost:2223`.

## Prerequisites

- The flake must be pushed — the installer fetches it from GitHub.
- An **aarch64 minimal** NixOS ISO from [nixos.org/download](https://nixos.org/download/) (Minimal ISO image → 64-bit ARM).

## 1. Boot the installer (one-time)

> **Not yet re-run since the UTM→vfkit cutover.** The console install in §2 is
> backend-agnostic, but the vfkit invocation that boots the *installer ISO* is
> reconstructed from `scripts/devon-vfkit.sh start` (the same EFI removable-media
> path that boots the installed disk) plus the ISO and a blank disk — validate it
> on first use. The declarative raw-efi image (TODO, needs a `nix.linux-builder`)
> is the intended replacement for this whole step.

Create the blank target disk, then boot the minimal ISO under vfkit with a
graphical console (`--gui`) for the install. Mirror the device set from
`devon start` (gvproxy networking, Rosetta, rng) and attach the ISO as a
second `virtio-blk`:

```sh
mkdir -p ~/.local/share/devon-vfkit
truncate -s 64G ~/.local/share/devon-vfkit/devon.img
# then boot, roughly (see scripts/devon-vfkit.sh for the full device set):
#   vfkit --cpus 4 --memory 6144 --gui \
#     --bootloader efi,variable-store=<vars>,create \
#     --device virtio-blk,path=~/.local/share/devon-vfkit/devon.img \
#     --device virtio-blk,path=<minimal.iso> \
#     --device virtio-net,unixSocketPath=<gvproxy.sock>,mac=5a:94:ef:e4:0c:ee \
#     --device rosetta,mountTag=rosetta --device virtio-rng
```

Rosetta must be attached or the first boot of the installed system drops to
emergency mode (the config declares a Rosetta virtiofs mount). This backend has
no snapshots; restarting from the ISO is the retry path.

## 2. Install (console, one-time)

Boot the VM and log in at the `nixos@nixos` prompt. The graphical console has no
host paste, so type the commands:

```sh
sudo -i
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart root ext4 512MB 100%
parted /dev/vda -- mkpart ESP fat32 1MB 512MB
parted /dev/vda -- set 2 esp on
mkfs.ext4 -L nixos /dev/vda1
mkfs.fat -F 32 -n boot /dev/vda2
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

# Swap: the worktrunk Rust build OOMs in 6 GB. Use dd, not fallocate —
# swapon rejects holey files on ext4.
dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192
chmod 600 /mnt/swapfile && mkswap /mnt/swapfile && swapon /mnt/swapfile

# Enable flakes via env; --extra-experimental-features is not a nixos-install flag.
export NIX_CONFIG="extra-experimental-features = nix-command flakes"
nixos-install --flake github:timkalan/dotfiles#devon

# Set a root password when prompted: console break-glass only; ssh is key-only.
swapoff /mnt/swapfile && rm /mnt/swapfile
reboot
```

After reboot, stop the VM and relaunch without the ISO so it boots from disk —
`devon start` attaches only `devon.img`.

**Installer media read errors** (`SQUASHFS error: Failed to read block` or
`Killed` mid-install) are Apple Virtualization mis-reading the *installer media*,
not the disk (the installed disk is safe). Stop and start the VM for a fresh ISO
read, then re-run from the `mkfs` lines — the partition table persists.

## 3. First connection + dotfiles

From the Mac host, start devon and log in. `devon` is the launcher command
(built by `scripts/devon-vfkit.nix`, on PATH via `hosts/diego/home.nix`); it
forwards diego's 1Password SSH agent (`ssh -A`), so no private key lives on devon:

```sh
devon start
devon ssh                     # log in  (≡ ssh devon)
```

The nvim and CLAUDE.md configs are out-of-store symlinks into `~/dotfiles`
(`shared/home.nix`), so they dangle until the repo is cloned. The `insteadOf`
git rewrite clones over the forwarded agent key:

```sh
git clone git@github.com:timkalan/dotfiles ~/dotfiles
```

The symlinks resolve as soon as `~/dotfiles` exists — no rebuild needed. Project
repos live here too; never develop across virtiofs shares.

## 4. Daily use

```sh
devon start    # boot (headless; sshd on localhost:2223)
devon ssh      # log in
devon status   # vfkit / gvproxy / VM state
devon logs     # serial + vfkit + gvproxy logs (break-glass)
devon stop     # graceful ACPI shutdown — frees RAM/CPU
```

A stopped devon costs zero RAM/CPU — only the sparse disk
(`~/.local/share/devon-vfkit/devon.img`) remains. Nothing auto-starts it. It
runs headless; for a console, `DEVON_VFKIT_GUI=1 devon start` opens a
window (break-glass until `console=hvc0` is wired).

Rebuild after a config change, from inside devon:

```sh
sudo nixos-rebuild switch --flake github:timkalan/dotfiles#devon
```

## 5. Verify

```sh
docker run --rm hello-world
docker run --rm --platform linux/amd64 alpine uname -m   # -> x86_64 (Rosetta)
sudo fstrim -v /                                         # sparse reclaim
```

## Notes

- **Kernel pinned to 6.12** (`boot.kernelPackages`): Rosetta on macOS 15 can't
  parse `AT_HWCAP3` from kernels ≥6.13 (`rosetta error: unhandled auxillary vector type 29`). Drop the pin on macOS 26+ (newer Rosetta).
- **Sizing:** 6 GB runs fine but is tight for building the closure from source
  (worktrunk builds from source, not from the binary cache). The swap step covers install; a 12–16 GB VM avoids it.
- **Teardown:** `devon stop` frees RAM/CPU; delete
  `~/.local/share/devon-vfkit/` to reclaim the disk. The recipe lives here —
  recreate in ~30 min, or import a generated disk image in ~2 min.
- **Web dev:** bind `0.0.0.0` in the guest and reach it through an ssh `-L`
  tunnel — gvproxy NATs the guest, so the host can't hit the VM IP directly.
