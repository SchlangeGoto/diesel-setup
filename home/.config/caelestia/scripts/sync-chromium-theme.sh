#!/usr/bin/env bash
# Build the generated Caelestia theme as a signed local CRX and install it as a
# Chromium external theme. Chromium picks it up on its next start.
set -euo pipefail

STATE="${XDG_STATE_HOME:-$HOME/.local/state}/caelestia/theme/chromium-theme.json"
OUT="${XDG_DATA_HOME:-$HOME/.local/share}/caelestia/chromium"
KEY="${XDG_CONFIG_HOME:-$HOME/.config}/caelestia/chromium/caelestia.pem"
PROFILE="${XDG_CONFIG_HOME:-$HOME/.config}/chromium"
EXTDIR="$PROFILE/External Extensions"
VERSION_FILE="$OUT/version"

[[ -f "$STATE" ]] || {
    echo "error: $STATE has not been rendered yet" >&2
    exit 1
}

command -v chromium >/dev/null 2>&1 || exit 0

mkdir -p "$OUT" "$(dirname "$KEY")" "$EXTDIR"

version=$(( $(cat "$VERSION_FILE" 2>/dev/null || echo 0) + 1 ))
echo "$version" > "$VERSION_FILE"

build="$(mktemp -d /tmp/caelestia-chromium.XXXXXX)"
trap 'rm -rf "$build" "$build.crx" "$build.pem"' EXIT

python3 - "$STATE" "$build/manifest.json" "$version" <<'PY'
import json
import sys

source, target, version = sys.argv[1], sys.argv[2], sys.argv[3]
with open(source) as f:
    manifest = json.load(f)
manifest["version"] = f"1.0.{version}"
with open(target, "w") as f:
    json.dump(manifest, f, indent=2)
    f.write("\n")
PY

pack_args=(
    --user-data-dir=/tmp/caelestia-chromium-pack
    --no-first-run
    --pack-extension="$build"
)
if [[ -f "$KEY" ]]; then
    pack_args+=(--pack-extension-key="$KEY")
fi

if ! chromium "${pack_args[@]}" >/tmp/caelestia-chromium-pack.log 2>&1; then
    cat /tmp/caelestia-chromium-pack.log >&2
    exit 1
fi

[[ -f "$build.crx" ]] || {
    echo "error: Chromium did not produce a CRX" >&2
    exit 1
}

if [[ ! -f "$KEY" ]]; then
    [[ -f "$build.pem" ]] || {
        echo "error: Chromium did not produce a key" >&2
        exit 1
    }
    mv "$build.pem" "$KEY"
    chmod 600 "$KEY"
fi

cp "$build.crx" "$OUT/caelestia.crx"

python3 - "$KEY" "$OUT/caelestia.crx" "$EXTDIR" "$version" <<'PY'
import hashlib
import json
import subprocess
import sys

key, crx, extdir, version = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
der = subprocess.check_output(
    ["openssl", "rsa", "-in", key, "-pubout", "-outform", "DER"],
    stderr=subprocess.DEVNULL,
)
sha = hashlib.sha256(der).hexdigest()[:32]
extension_id = "".join(chr(ord("a") + int(ch, 16)) for ch in sha)

with open(f"{extdir}/{extension_id}.json", "w") as f:
    json.dump(
        {
            "external_crx": crx,
            "external_version": f"1.0.{version}",
        },
        f,
        indent=2,
    )
    f.write("\n")

print(f"  ✓ Chromium theme {extension_id} (1.0.{version})")
PY

echo "Restart Chromium to apply the updated theme."
