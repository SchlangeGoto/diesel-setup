#!/usr/bin/env bash
# Restore diesel-setup on a fresh Arch Linux installation.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME}"
DRY_RUN=0
INSTALL_PACKAGES=1
APPLY_HARDWARE=0
SECRETS_DIR="${DIESEL_SECRETS_DIR:-$HOME_DIR/Projects/System/diesel-secrets}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME_DIR/.setup-backup/$STAMP"

usage() {
    cat <<'EOF'
Usage: ./install.sh [--dry-run] [--no-packages] [--hardware]

  --dry-run       Print what would happen; change nothing.
  --no-packages   Skip pacman/AUR installation.
  --hardware      Also apply hardware-specific files (fstab, 40_custom,
                  timeshift.json). Review the diffs first!

The private secrets repo is expected at ~/Projects/System/diesel-secrets
or $DIESEL_SECRETS_DIR.
EOF
}

while (($#)); do
    case "$1" in
        --dry-run) DRY_RUN=1 ;;
        --no-packages) INSTALL_PACKAGES=0 ;;
        --hardware) APPLY_HARDWARE=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
    esac
    shift
done

say() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mWARN:\033[0m %s\n' "$*" >&2; }

run() {
    if ((DRY_RUN)); then
        printf '  + %s\n' "$*"
    else
        "$@"
    fi
}

sudo_run() {
    if ((DRY_RUN)); then
        printf '  + sudo %s\n' "$*"
    else
        sudo "$@"
    fi
}

[[ -f /etc/arch-release ]] || {
    echo "This installer is for Arch Linux." >&2
    exit 1
}

say "Backup directory"
run mkdir -p "$BACKUP_DIR"

if ((INSTALL_PACKAGES)); then
    say "Bootstrap packages"
    sudo_run pacman -S --needed --noconfirm git rsync git-lfs base-devel

    say "Official packages"
    if [[ -s "$REPO_DIR/packages/pacman-explicit.txt" ]]; then
        sudo_run pacman -S --needed --noconfirm - < "$REPO_DIR/packages/pacman-explicit.txt"
    fi
    if [[ -s "$REPO_DIR/packages/extra-explicit.txt" ]]; then
        sudo_run pacman -S --needed --noconfirm - < "$REPO_DIR/packages/extra-explicit.txt"
    fi

    if ! command -v yay >/dev/null 2>&1; then
        say "Installing yay"
        tmp="$(mktemp -d)"
        run git clone https://aur.archlinux.org/yay.git "$tmp/yay"
        (cd "$tmp/yay" && run makepkg -si --noconfirm)
        rm -rf "$tmp"
    fi

    say "AUR packages"
    if [[ -s "$REPO_DIR/packages/aur-explicit.txt" ]]; then
        run yay -S --needed --noconfirm - < "$REPO_DIR/packages/aur-explicit.txt"
    fi
fi

if ((INSTALL_PACKAGES)); then
    say "Editor extensions"
    if command -v codium >/dev/null 2>&1 && [[ -s "$REPO_DIR/packages/vscodium-extensions.txt" ]]; then
        while IFS= read -r ext; do
            [[ -n "$ext" ]] && run codium --install-extension "$ext" --force
        done < "$REPO_DIR/packages/vscodium-extensions.txt"
    fi
    if command -v code >/dev/null 2>&1 && [[ -s "$REPO_DIR/packages/code-extensions.txt" ]]; then
        while IFS= read -r ext; do
            [[ -n "$ext" ]] && run code --install-extension "$ext" --force
        done < "$REPO_DIR/packages/code-extensions.txt"
    fi

    say "Global npm packages"
    if command -v npm >/dev/null 2>&1 && [[ -s "$REPO_DIR/packages/npm-global.txt" ]]; then
        mapfile -t npm_pkgs < <(grep -v '^$' "$REPO_DIR/packages/npm-global.txt")
        if ((${#npm_pkgs[@]})); then
            run npm install -g "${npm_pkgs[@]}"
        fi
    fi
fi

say "Restoring home"
while IFS= read -r rel || [[ -n "$rel" ]]; do
    [[ -z "$rel" || "$rel" == \#* ]] && continue
    src="$REPO_DIR/home/$rel"
    dest="$HOME_DIR/$rel"
    [[ -e "$src" ]] || continue

    if [[ -e "$dest" ]]; then
        mkdir -p "$BACKUP_DIR/home/$(dirname "$rel")"
        run cp -a "$dest" "$BACKUP_DIR/home/$rel"
    fi

    if [[ -d "$src" ]]; then
        run mkdir -p "$dest"
        run rsync -a "$src/" "$dest/"
    else
        run mkdir -p "$(dirname "$dest")"
        run rsync -a "$src" "$dest"
    fi
done < "$REPO_DIR/manifests/home.txt"

if [[ -f "$REPO_DIR/home/dconf.ini" ]] && command -v dconf >/dev/null 2>&1; then
    say "Restoring dconf"
    if ((DRY_RUN)); then
        echo "  + dconf load / < $REPO_DIR/home/dconf.ini"
    else
        dconf load / < "$REPO_DIR/home/dconf.ini" || warn "dconf load failed"
    fi
fi

say "Restoring system files"
while IFS= read -r rel || [[ -n "$rel" ]]; do
    [[ -z "$rel" || "$rel" == \#* ]] && continue
    src="$REPO_DIR/system/$rel"
    dest="/$rel"
    [[ -e "$src" ]] || continue

    if [[ -e "$dest" ]]; then
        mkdir -p "$BACKUP_DIR/system/$(dirname "$rel")"
        sudo_run cp -a "$dest" "$BACKUP_DIR/system/$rel"
    fi

    if [[ -d "$src" ]]; then
        sudo_run mkdir -p "$dest"
        sudo_run rsync -a "$src/" "$dest/"
    else
        sudo_run mkdir -p "$(dirname "$dest")"
        sudo_run rsync -a "$src" "$dest"
    fi
done < "$REPO_DIR/manifests/system-safe.txt"

if ((APPLY_HARDWARE)); then
    say "Applying hardware-specific system files"
    while IFS= read -r rel || [[ -n "$rel" ]]; do
        [[ -z "$rel" || "$rel" == \#* ]] && continue
        src="$REPO_DIR/system/manual/$rel"
        dest="/$rel"
        [[ -e "$src" ]] || continue
        warn "Applying $rel; verify UUIDs/entries afterwards"
        sudo_run mkdir -p "$(dirname "$dest")"
        sudo_run rsync -a "$src" "$dest"
    done < "$REPO_DIR/manifests/system-manual.txt"
else
    warn "Hardware-specific files were NOT applied: $(tr '\n' ' ' < "$REPO_DIR/manifests/system-manual.txt")"
    warn "Review system/manual/ and rerun with --hardware if appropriate."
fi

say "Restoring wallpapers"
if [[ -d "$REPO_DIR/wallpapers" ]]; then
    if grep -RIl 'git-lfs.github.com/spec' "$REPO_DIR/wallpapers" >/dev/null 2>&1; then
        say "Fetching Git LFS objects"
        run git -C "$REPO_DIR" lfs pull
    fi
    run mkdir -p "$HOME_DIR/Pictures/Wallpapers"
    run rsync -a "$REPO_DIR/wallpapers/" "$HOME_DIR/Pictures/Wallpapers/"
fi

say "Caelestia shell"
CAELESTIA_DIR="$HOME_DIR/.config/quickshell/caelestia"
if [[ -d "$CAELESTIA_DIR" ]]; then
    run mv "$CAELESTIA_DIR" "$BACKUP_DIR/caelestia"
fi
base="v2.5.0"
[[ -f "$REPO_DIR/caelestia/base.txt" ]] && base="$(cat "$REPO_DIR/caelestia/base.txt")"
run mkdir -p "$(dirname "$CAELESTIA_DIR")"
run git clone --branch "$base" https://github.com/caelestia-dots/shell.git "$CAELESTIA_DIR"
if compgen -G "$REPO_DIR/caelestia/patches/*.patch" >/dev/null; then
    run git -C "$CAELESTIA_DIR" checkout -b local/agenda
    for patch in "$REPO_DIR"/caelestia/patches/*.patch; do
        run git -C "$CAELESTIA_DIR" am "$patch"
    done
fi

say "Services"
for unit in sddm.service NetworkManager.service bluetooth.service grub-btrfsd.service proton.VPN.service; do
    if systemctl cat "$unit" >/dev/null 2>&1; then
        sudo_run systemctl enable "$unit"
    else
        warn "system unit not installed: $unit"
    fi
done
if command -v systemctl >/dev/null 2>&1; then
    for unit in appimagelauncherd.service agenda-notify.timer; do
        if systemctl --user cat "$unit" >/dev/null 2>&1; then
            run systemctl --user enable --now "$unit"
        fi
    done
fi

say "Regenerating boot files"
if command -v grub-mkconfig >/dev/null 2>&1 && [[ -f /etc/default/grub ]]; then
    sudo_run grub-mkconfig -o /boot/grub/grub.cfg
fi
if command -v mkinitcpio >/dev/null 2>&1; then
    sudo_run mkinitcpio -P
fi
sudo_run systemctl daemon-reload

say "Private secrets"
if [[ -x "$SECRETS_DIR/unseal.sh" ]]; then
    echo "Run: $SECRETS_DIR/unseal.sh"
else
    warn "Secrets repo not found at $SECRETS_DIR; see docs/manual-steps.md"
fi

say "Done"
cat <<EOF
Backups of replaced files: $BACKUP_DIR

Next:
  1. restore secrets: $SECRETS_DIR/unseal.sh
  2. log into GitHub, Proton, Todoist, Teams, Thunderbird, browsers
  3. start the shell: caelestia shell -d
  4. reboot
EOF
