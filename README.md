# diesel-setup

Reproducible Arch Linux + Hyprland + Caelestia setup for `diesel`.

This repository is the **public** part of the backup: dotfiles, shell configs,
system configuration, package lists, scripts and wallpapers.

**No secrets live here.** SSH keys, tokens, Wi-Fi profiles, personal OpenCode
skills and account data live in the private `diesel-secrets` repository.

## Quick start on a fresh Arch install

Prerequisites: a working Arch base install, `git`, `base-devel`, and a user
account. The installer needs `sudo`.

```sh
git clone git@github.com:SchlangeGoto/diesel-setup.git ~/diesel-setup
cd ~/diesel-setup
./install.sh
```

The installer:

1. installs official and AUR packages
2. restores `home/` into `$HOME` (with backups of existing files)
3. restores the safe system files and GRUB/SDDM config
4. restores the wallpapers
5. clones the Caelestia shell and applies the local patches
6. enables services and regenerates GRUB/initramfs

After that, run the private secrets restore and log into the accounts that are
not stored here.

## Update the backup on the current machine

```sh
cd ~/diesel-setup
./backup.sh
```

`backup.sh` refreshes configs, package lists, Caelestia patches and hardware
notes, then creates a commit. Push it with `git push`.

## Structure

```text
manifests/       What is backed up
home/            $HOME-relative configs and scripts
system/          /-relative system files
wallpapers/      Pictures/Wallpapers (Git LFS)
caelestia/       Patches for the local Caelestia shell checkout
packages/        pacman/AUR/npm/editor extension lists
docs/            Recovery, hardware, manual steps
```

## What is intentionally not here

- Browser profiles, cookies, history and passwords
- Thunderbird mail/profile
- Teams, Todoist, Vesktop/Equibop, Obsidian app data
- VMs, Minecraft/Modrinth/Prism data, game libraries
- SSH keys, tokens, Wi-Fi PSKs and other credentials

Those are either recreated by logging in again, or backed up separately with
Restic/external storage. See `docs/manual-steps.md`.

## Update / rebase

Caelestia is applied as patches on top of the upstream tag in `caelestia/`.
When Caelestia updates, rebase the local checkout and re-export the patches:

```sh
cd ~/.config/quickshell/caelestia
git fetch --tags
git rebase v2.6.0
~/Projects/diesel-setup/backup.sh
```

## Security

The public repo must never receive credentials. The backup script uses
allowlists (`manifests/*.txt`) and `.gitignore` as a second guard. If you add a
new secret-bearing path, add it to `.gitignore` first.

The private companion repo is `SchlangeGoto/diesel-secrets`. It stores one
GPG-encrypted archive; the passphrase is not in either repository.

## Wallpapers

`wallpapers/` is a personal collection and is redistributed publicly because
this repository is public. Check the original licenses before reusing the
images elsewhere.
