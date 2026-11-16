# Manual steps after restore

These are intentionally not automated because they contain credentials, app
state or hardware-specific data.

## Secrets

```sh
git clone git@github.com:SchlangeGoto/diesel-secrets.git ~/diesel-secrets
~/diesel-secrets/unseal.sh
```

The archive contains SSH keys/config, `~/.face`, the SDDM avatar, gws/gh/gcloud
credentials, Caelestia/Todoist secrets, the Chromium extension private key and
personal OpenCode agents/commands/skills.

## Accounts / logins

- GitHub CLI: `gh auth login`
- Google Workspace CLI: install `gws` from <https://github.com/googleworkspace/cli> to `/usr/local/bin/gws`, then run `gws auth login`. The Agenda helpers depend on it.
- Proton VPN: `protonvpn signin`
- Todoist: desktop app login (the API token comes from the secrets archive)
- Teams: `teams-for-linux` login
- Thunderbird: re-add accounts; mail is not backed up
- Browsers: sign in to Firefox/Zen/Chromium sync; profiles and cookies are not
  backed up
- Obsidian: vault is in the separate `SchlangeGoto/obsidian` repository
- JetBrains / VSCodium: sign in and install extensions from the package lists
- OpenCode: provider auth is in the secrets archive; verify after restore

## SSH agent

The keys are restored with mode `600`. Start the agent normally through the
desktop session or:

```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## Network

Wi-Fi and WireGuard profiles are restored to
`/etc/NetworkManager/system-connections` by `unseal.sh`. Restart NetworkManager:

```sh
sudo systemctl restart NetworkManager
```

## Wallpaper / theme

The Caelestia state (scheme, wallpaper path, generated theme files) is restored
in `home/.local/state/caelestia`. If the wallpaper path differs, re-apply:

```sh
caelestia wallpaper -f ~/Pictures/Wallpapers/blue/wind-turbine-sea.jpg
```

The SDDM theme is synchronized by Caelestia's post-hook. Run it once as your
user if necessary:

```sh
sudo /usr/share/sddm/themes/caelestia/scripts/sync.sh --posthook
```

## Not restored

- Browser profiles/cookies/history/passwords
- Thunderbird mail/profile
- Teams/Todoist/Vesktop/Equibop/Obsidian app data
- VMs, Minecraft/Modrinth/Prism data
- Anything under `~/.cache`, `~/.local/share` that is app state

See `docs/exclusions.md`.
