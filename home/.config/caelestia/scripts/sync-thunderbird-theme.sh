#!/usr/bin/env bash
# Install the Caelestia Thunderbird theme into every Thunderbird profile.
#
# The actual colours live in ~/.local/state/caelestia/theme/ and are regenerated
# by Caelestia whenever the scheme changes. This script only creates the
# chrome/ symlinks and ensures userChrome.css is enabled.
set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/caelestia/theme"
chrome_css="$state_dir/thunderbird-userChrome.css"
content_css="$state_dir/thunderbird-userContent.css"

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
thunderbird_dirs=("$config_home/thunderbird" "$HOME/.thunderbird")

# Render the user templates with the current Caelestia scheme. This also picks
# up edits to the .css files in ~/.config/caelestia/templates.
echo ":: Rendering Caelestia templates…"
python3 - <<'PY'
from caelestia.utils.scheme import get_scheme
from caelestia.utils.theme import apply_user_templates

scheme = get_scheme()
apply_user_templates(scheme.colours, scheme.mode)
PY

if [[ ! -f "$chrome_css" || ! -f "$content_css" ]]; then
    echo "error: $chrome_css is missing" >&2
    exit 1
fi

install_profile() {
    local profile="$1"
    local chrome_dir="$profile/chrome"

    mkdir -p "$chrome_dir"

    for pair in "userChrome.css:$chrome_css" "userContent.css:$content_css"; do
        local name="${pair%%:*}"
        local source="${pair#*:}"
        local target="$chrome_dir/$name"

        # Keep a one-time backup of an existing hand-written file.
        if [[ -e "$target" && ! -L "$target" && ! -e "$target.caelestia-backup" ]]; then
            cp -a "$target" "$target.caelestia-backup"
        fi

        ln -sfn "$source" "$target"
    done

    local user_js="$profile/user.js"
    if [[ ! -f "$user_js" ]]; then
        printf '/* Added by the Caelestia Thunderbird theme */\n' > "$user_js"
    fi
    if ! grep -q 'toolkit.legacyUserProfileCustomizations.stylesheets' "$user_js"; then
        printf '\n/* Added by the Caelestia Thunderbird theme */\n' >> "$user_js"
        printf 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);\n' >> "$user_js"
    fi

    echo "  ✓ $profile"
}

found=0

for tb_dir in "${thunderbird_dirs[@]}"; do
    [[ -d "$tb_dir" ]] || continue

    profiles=()
    if [[ -f "$tb_dir/profiles.ini" ]]; then
        while IFS= read -r rel; do
            [[ -n "$rel" ]] || continue
            if [[ "$rel" = /* ]]; then
                candidate="$rel"
            else
                candidate="$tb_dir/$rel"
            fi
            [[ -d "$candidate" ]] && profiles+=("$candidate")
        done < <(awk -F= '/^Path=/{print $2}' "$tb_dir/profiles.ini")
    fi

    # Also handle a profile directory pointed at directly by the user.
    if [[ -f "$tb_dir/prefs.js" ]]; then
        profiles+=("$tb_dir")
    fi

    for profile in "${profiles[@]}"; do
        # Only real profiles (started at least once) get the theme.
        [[ -f "$profile/prefs.js" ]] || continue
        install_profile "$profile"
        found=1
    done
done

if [[ "$found" -eq 0 ]]; then
    echo "No Thunderbird profile with a prefs.js was found." >&2
    exit 1
fi

echo
echo "Done. Restart Thunderbird to apply the theme."
echo "Future Caelestia scheme changes update the files automatically;"
echo "Thunderbird applies them the next time it starts."
