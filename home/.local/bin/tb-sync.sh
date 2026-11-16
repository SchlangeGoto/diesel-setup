#!/usr/bin/env bash
# tb-sync.sh — force a Thunderbird mail sync without opening a window.
#
# If Thunderbird is already running: does nothing (it syncs on its own).
# Otherwise: starts it headless, waits for the mail store to stop changing,
# then shuts it down again.
#
# Usage:   tb-sync.sh [max_wait_seconds]
# Exit:    0 = synced (or already running), 1 = failure

set -uo pipefail

PROFILE="$HOME/.config/thunderbird/mrzd06wa.default-release"
TB_BIN="/usr/lib/thunderbird/thunderbird"
MAX_WAIT="${1:-180}"
STATE="${XDG_RUNTIME_DIR:-/tmp}/tb-sync"
LOCK="$STATE/lock"
LOG="$STATE/sync.log"
SETTLE=20        # seconds of no file changes = done
MIN_RUN=25       # let it connect before trusting "settled"

mkdir -p "$STATE" || exit 1
exec 9>"$LOCK" || exit 1
if ! flock -n 9; then
    echo "another tb-sync is already running"
    exit 0
fi

log() { echo "[$(date '+%F %T')] $*" | tee -a "$LOG"; }

if pgrep -u "$USER" -f "^${TB_BIN}" >/dev/null 2>&1; then
    log "Thunderbird is already running — it syncs on its own. Nothing to do."
    exit 0
fi

# fingerprint of the mail store: path + mtime + size of every index/mbox
fingerprint() {
    find "$PROFILE/ImapMail" "$PROFILE/Mail" \
         -type f \( -name '*.msf' -o -name '*.dat' -o -size +0c \) \
         -printf '%p %T@ %s\n' 2>/dev/null | sort | md5sum
}

log "starting headless Thunderbird..."
env -u DISPLAY -u WAYLAND_DISPLAY setsid "$TB_BIN" --headless --profile "$PROFILE" \
    >>"$LOG" 2>&1 &
TB_PID=$!
log "pid $TB_PID"

prev=""; stable=0; elapsed=0
while [ "$elapsed" -lt "$MAX_WAIT" ]; do
    sleep 5
    elapsed=$((elapsed + 5))
    cur="$(fingerprint)"
    if [ "$cur" = "$prev" ]; then
        stable=$((stable + 5))
    else
        stable=0
    fi
    prev="$cur"
    if [ "$elapsed" -ge "$MIN_RUN" ] && [ "$stable" -ge "$SETTLE" ]; then
        log "mail store settled after ${elapsed}s (no changes for ${stable}s)"
        break
    fi
    if ! kill -0 "$TB_PID" 2>/dev/null; then
        log "ERROR: Thunderbird exited unexpectedly"
        exit 1
    fi
done

if [ "$elapsed" -ge "$MAX_WAIT" ]; then
    log "WARNING: hit max wait (${MAX_WAIT}s) — stopping anyway; sync may be incomplete"
fi

log "shutting down headless Thunderbird (SIGTERM)..."
kill -TERM "$TB_PID" 2>/dev/null
for _ in $(seq 1 30); do
    kill -0 "$TB_PID" 2>/dev/null || break
    sleep 1
done
if kill -0 "$TB_PID" 2>/dev/null; then
    log "WARNING: did not exit after 30s — sending SIGKILL (indexes may need rebuilding)"
    kill -KILL "$TB_PID" 2>/dev/null
fi

log "done."
