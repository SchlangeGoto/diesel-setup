#!/usr/bin/env bash
# Refresh the public diesel-setup snapshot from the current machine.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME}"
PUSH=0

usage() {
    cat <<'EOF'
Usage: ./backup.sh [--push]

Refreshes:
  home/          from manifests/home.txt
  system/        from manifests/system-safe.txt and system-manual.txt
  wallpapers/    from ~/Pictures/Wallpapers
  packages/      pacman/AUR/npm/editor extensions
  caelestia/     exported patches from the local shell checkout
  docs/           hardware snapshot

Creates a local git commit. --push also pushes to origin.
EOF
}

while (($#)); do
    case "$1" in
        --push) PUSH=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
    esac
    shift
done

say() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mWARN:\033[0m %s\n' "$*" >&2; }

RSYNC_EXCLUDES=(
    --exclude=.git
    --exclude=__pycache__
    --exclude='*.pyc'
    --exclude=.cache
    --exclude=Cache
    --exclude=CachedData
    --exclude=GPUCache
    --exclude='Code Cache'
    --exclude=node_modules
    --exclude='*.log'
    --exclude=.DS_Store
)

backup_path() {
    local src="$1" dest="$2"

    if [[ -d "$src" ]]; then
        mkdir -p "$dest"
        rsync -a --delete "${RSYNC_EXCLUDES[@]}" "$src/" "$dest/"
    elif [[ -e "$src" ]]; then
        mkdir -p "$(dirname "$dest")"
        rsync -a "${RSYNC_EXCLUDES[@]}" "$src" "$dest"
    else
        warn "missing: $src"
    fi
}

backup_manifest() {
    local manifest="$1" root="$2" dest_root="$3" mode="$4"

    while IFS= read -r rel || [[ -n "$rel" ]]; do
        [[ -z "$rel" || "$rel" == \#* ]] && continue
        local src="$root/$rel"
        local dest
        if [[ "$mode" == "manual" ]]; then
            dest="$dest_root/manual/$rel"
        else
            dest="$dest_root/$rel"
        fi
        backup_path "$src" "$dest"
    done < "$manifest"
}

say "Home configs"
backup_manifest "$REPO_DIR/manifests/home.txt" "$HOME_DIR" "$REPO_DIR/home" normal

say "System configs"
backup_manifest "$REPO_DIR/manifests/system-safe.txt" "/" "$REPO_DIR/system" normal
backup_manifest "$REPO_DIR/manifests/system-manual.txt" "/" "$REPO_DIR/system" manual

say "Wallpapers"
backup_path "$HOME_DIR/Pictures/Wallpapers" "$REPO_DIR/wallpapers"

say "dconf"
mkdir -p "$REPO_DIR/home"
dconf dump / > "$REPO_DIR/home/dconf.ini" 2>/dev/null || warn "dconf dump failed"

say "Package lists"
mkdir -p "$REPO_DIR/packages"
pacman -Qqen > "$REPO_DIR/packages/pacman-explicit.txt"
pacman -Qqem > "$REPO_DIR/packages/aur-explicit.txt"
pacman -Q     > "$REPO_DIR/packages/pacman-all.txt"
pacman -Qm    > "$REPO_DIR/packages/foreign-all.txt"

npm ls -g --depth=0 --json 2>/dev/null \
    | jq -r '.dependencies // {} | keys[]' > "$REPO_DIR/packages/npm-global.txt" \
    || warn "npm global list failed"

pnpm ls -g --depth 0 2>/dev/null > "$REPO_DIR/packages/pnpm-global.txt" \
    || warn "pnpm global list failed"

codium --list-extensions 2>/dev/null > "$REPO_DIR/packages/vscodium-extensions.txt" \
    || warn "VSCodium extension list failed"
code --list-extensions 2>/dev/null > "$REPO_DIR/packages/code-extensions.txt" \
    || warn "Code extension list failed"

systemctl list-unit-files --state=enabled --no-pager 2>/dev/null \
    > "$REPO_DIR/packages/system-services.txt" || true
systemctl --user list-unit-files --state=enabled --no-pager 2>/dev/null \
    > "$REPO_DIR/packages/user-services.txt" || true

say "Hardware snapshot"
mkdir -p "$REPO_DIR/docs"
{
    echo "# Hardware snapshot"
    echo
    echo "Generated: $(date -Is)"
    echo
    echo "## System"
    echo '```'
    uname -a
    echo '```'
    echo
    echo "## CPU"
    echo '```'
    lscpu | sed -n '1,30p'
    echo '```'
    echo
    echo "## PCI"
    echo '```'
    lspci -nnk
    echo '```'
    echo
    echo "## USB"
    echo '```'
    command -v lsusb >/dev/null 2>&1 && lsusb || echo "(lsusb not installed)"
    echo '```'
    echo
    echo "## Disks"
    echo '```'
    lsblk -f
    echo '```'
    echo
    echo "## Memory"
    echo '```'
    free -h
    echo '```'
    echo
    echo "## Filesystems"
    echo '```'
    df -hT
    echo '```'
    echo
    echo "## EFI boot entries"
    echo '```'
    efibootmgr -v 2>/dev/null || true
    echo '```'
} > "$REPO_DIR/docs/hardware.md"

say "Caelestia patches"
CAELESTIA_DIR="$HOME_DIR/.config/quickshell/caelestia"
if [[ -d "$CAELESTIA_DIR/.git" ]]; then
    rm -rf "$REPO_DIR/caelestia/patches"
    mkdir -p "$REPO_DIR/caelestia/patches"
    base="v2.5.0"
    if [[ -f "$REPO_DIR/caelestia/base.txt" ]]; then
        base="$(cat "$REPO_DIR/caelestia/base.txt")"
    fi
    if git -C "$CAELESTIA_DIR" rev-parse --verify "$base" >/dev/null 2>&1; then
        git -C "$CAELESTIA_DIR" format-patch "$base"..HEAD \
            -o "$REPO_DIR/caelestia/patches" >/dev/null
        printf '%s\n' "$base" > "$REPO_DIR/caelestia/base.txt"
        git -C "$CAELESTIA_DIR" rev-parse HEAD > "$REPO_DIR/caelestia/commit.txt"
        git -C "$CAELESTIA_DIR" status --short > "$REPO_DIR/caelestia/status.txt" || true
        echo "Exported $(find "$REPO_DIR/caelestia/patches" -name '*.patch' | wc -l) patch(es) from $base"
    else
        warn "Caelestia base tag '$base' not found; patches not exported"
    fi
else
    warn "missing Caelestia checkout: $CAELESTIA_DIR"
fi

say "Git"
cd "$REPO_DIR"
git add -A
if git diff --cached --quiet; then
    echo "No changes."
else
    git commit -m "backup: $(date '+%Y-%m-%d %H:%M')"
fi

if ((PUSH)); then
    git push
fi

say "Done"
echo "Repository: $REPO_DIR"
if ((!PUSH)); then
    echo "Push with: git push"
fi
