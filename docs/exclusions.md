# What is not backed up here

This repository is for **configuration and reproducible setup**, not for large
app data. These paths are intentionally excluded:

| Path | Size (approx.) | Reason |
|---|---:|---|
| `~/Documents/VMs` | 28 GB | VM disks; use Restic/external storage |
| `~/.local/share/ModrinthApp` | 36 GB | game data |
| `~/.config/chromium` | 8.9 GB | browser profile/cache |
| `~/.config/mozilla` | 1.7 GB | Firefox profile/mail-adjacent data |
| `~/.config/teams-for-linux` | 1.3 GB | Teams cache/session |
| `~/.config/thunderbird` | 1.3 GB | mail/profile |
| `~/.config/vesktop` | 1.6 GB | Discord cache/session |
| `~/.local/share/JetBrains` | 8.9 GB | IDE caches |
| `~/.local/share/opencode` | 601 MB | sessions/cache |
| `~/.opencode-mem` | 543 MB | memory DB |
| `~/.od-opencode` | 3.6 GB | tool state |
| `~/.config/obsidian` | 122 MB | app cache; vault is in `SchlangeGoto/obsidian` |
| `~/Projects/Web` | 3.5 GB | project repos/node_modules; use their Git remotes |
| `~/Projects/Minecraft` | 550 MB | game project data; remotes exist |
| `~/.cache`, `~/.local/share/Trash` | large | caches/trash |

## Recommended large-data backup

Use Restic (or Borg) to an external disk or the Proxmox host for:

- `~/Documents`
- `~/Projects` (working copies, not just remotes)
- `~/.config` app data that matters (browser/mail/Teams)
- `~/.local/share` game/IDE data

A simple Restic repository on an external disk:

```sh
restic init --repo /run/media/$USER/backup/restic
restic backup --repo /run/media/$USER/backup/restic \
  "$HOME/Documents" "$HOME/Projects" "$HOME/.config"
```

Keep the Restic password in your password manager, not in this repo.

## Secrets

Never add these to `diesel-setup`:

- `~/.ssh/id_*`
- `~/.config/gws`
- `~/.config/gh/hosts.yml`
- `~/.config/gcloud`
- `~/.config/opencode/service.json`
- `~/.config/caelestia/secrets`
- `~/.config/caelestia/chromium/caelestia.pem`
- `~/.wallpaper_renamer.json` (NVIDIA key)
- `/etc/NetworkManager/system-connections`
- `~/.face` / SDDM avatar

They belong in the private `diesel-secrets` repository.
