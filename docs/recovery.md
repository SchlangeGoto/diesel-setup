# Recovery: fresh Arch install

This is the shortest reliable path back to a working `diesel` system.

## 1. Base Arch

Boot the Arch ISO and install a base system. The current machine uses:

- UEFI, GRUB
- NVMe, Btrfs, subvolumes `@` (root) and `@home`
- Separate EFI partition
- No LUKS on the Arch install

Create the user `kraftstoff` (or adapt paths and usernames in `home/`).
Install at least:

```sh
pacman -S --needed git base-devel rsync git-lfs
```

Mount the target system and `arch-chroot` into it.

## 2. Clone the setup

```sh
git clone git@github.com:SchlangeGoto/diesel-setup.git ~/diesel-setup
cd ~/diesel-setup
```

If the repository was cloned without `git-lfs`, install it first and run
`git lfs pull` before restoring wallpapers.

## 3. Run the installer

```sh
./install.sh --dry-run   # inspect
./install.sh
```

The installer restores:

- packages from `packages/pacman-explicit.txt` and `packages/aur-explicit.txt`
- `home/` into `$HOME`
- safe system files (`system/`)
- wallpapers
- the Caelestia shell checkout plus local patches
- services, GRUB config and initramfs

Existing files are copied to `~/.setup-backup/<timestamp>/`.

`etc/fstab`, `etc/grub.d/40_custom` and the Timeshift configs are **not**
applied automatically because they contain disk UUIDs. Review them first:

```sh
less system/manual/etc/fstab
less system/manual/etc/grub.d/40_custom
```

Then either edit them for the new disk and copy them manually, or rerun:

```sh
./install.sh --hardware
```

## 4. GRUB

If GRUB is not installed yet:

```sh
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

Do not copy `grub.cfg` from the backup; it is generated.

## 5. Secrets

```sh
git clone git@github.com:SchlangeGoto/diesel-secrets.git ~/diesel-secrets
~/diesel-secrets/unseal.sh
sudo systemctl restart NetworkManager
```

Then re-login to services that are not stored in the archive.

## 6. Caelestia

The installer clones upstream Caelestia at the pinned tag and applies the local
patches. Start the shell after logging into Hyprland:

```sh
caelestia shell -d
```

Check `docs/caelestia.md` for the update/rebase workflow.

## 7. Data that is not in this repo

VMs, browser profiles, mail, game data and other large data must be restored
separately (Restic/external disk). See `docs/exclusions.md`.
