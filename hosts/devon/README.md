# devon — headless NixOS dev VM

A headless NixOS guest under UTM (Apple Virtualization), reached over `ssh`. A
real Linux dev box on the Mac — Docker, x86 binaries via Rosetta, the full
dotfiles stack — while the macOS host stays a thin layer. devon is disposable:
everything but uncommitted code is rebuildable from this repo.

Config: `hosts/devon/{default,home,hardware-configuration}.nix` and
`nixosConfigurations."devon"` in `flake.nix`. UTM is installed via the `utm`
cask in `hosts/diego/homebrew.nix`.

## Prerequisites

- The flake must be pushed — the installer fetches it from GitHub.
- An **aarch64 minimal** NixOS ISO from nixos.org.

## 1. Create the VM (UTM, one-time GUI)

UTM → Create → Virtualize → Linux:

- Tick **Use Apple Virtualization**; **Enable Rosetta** then appears → tick it.
  Skipping Rosetta drops the first boot into emergency mode, because the config
  declares a Rosetta virtiofs mount.
- Boot ISO image → the downloaded ISO.
- 4 CPU / 6 GB / 60 GB. No shared directory.
- The summary must read **Apple Virtualization** — the backend is fixed at
  creation and Rosetta requires it. Name the VM `devon`.

This backend has no snapshots; the booted installer ISO is itself the retry
path if anything goes wrong.

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
# until feat/devon is merged to main, use: github:timkalan/dotfiles/feat/devon#devon

# Set a root password when prompted: console break-glass only; ssh is key-only.
swapoff /mnt/swapfile && rm /mnt/swapfile
reboot
```

After reboot, eject the ISO in UTM (drive dropdown in the toolbar) so the VM
boots from disk.

**ISO read errors:** `SQUASHFS error: Failed to read block` or `Killed`
mid-install is Apple Virtualization mis-reading the installer *media*, not the
disk (the installed disk is safe; UTM ≥4.5 sets `.cached`/NVMe). Stop and start
the VM for a fresh ISO read, then re-run from the `mkfs` lines — the partition
table persists.

## 3. First connection + dotfiles

From the Mac host (not the VM console):

```sh
ssh timkalan@devon.local      # avahi publishes the name; ssh is key-only, authorized via keys.identity
# if devon.local doesn't resolve, read the IP from the console: ip a
```

The nvim and CLAUDE.md configs are out-of-store symlinks into `~/dotfiles`
(`shared/home.nix`), so they dangle until the repo is cloned. No private key
lives on devon: diego forwards its 1Password SSH agent (`ForwardAgent` for
`devon.local` in `hosts/diego/home.nix`), and the `insteadOf` git rewrite clones
over that forwarded key:

```sh
git clone git@github.com:timkalan/dotfiles ~/dotfiles
```

The symlinks resolve as soon as `~/dotfiles` exists — no rebuild needed. Project
repos live here too; never develop across virtiofs shares.

## 4. Daily use

```sh
utmctl start devon            # or the UTM ▶ button; keep UTM.app open for utmctl
ssh timkalan@devon.local
utmctl stop devon             # or sudo poweroff over ssh — frees RAM/CPU
```

A stopped devon costs zero RAM/CPU — only the sparse disk remains. Nothing
auto-starts it. A display window opens on start (display output stays on for
break-glass); close it (Cmd-W) and the VM keeps running.

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
- **Teardown:** delete the VM in UTM and all space/RAM returns (only the sparse
  disk existed). The recipe lives here — recreate in ~30 min, or import a
  generated disk image in ~2 min.
- **Web dev:** bind `0.0.0.0` and hit the VM IP from the host browser.
