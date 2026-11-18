# Caelestia shell

The shell is not vendored. `caelestia/patches/` contains the local commits on
top of upstream Caelestia.

- Upstream: `https://github.com/caelestia-dots/shell`
- Base tag: `caelestia/base.txt`
- Local branch: `local/agenda`

The local checkout lives at:

```text
~/.config/quickshell/caelestia
```

## Restore

`install.sh` clones the pinned tag and applies all patches:

```sh
git clone --branch v2.5.0 https://github.com/caelestia-dots/shell.git \
  ~/.config/quickshell/caelestia
cd ~/.config/quickshell/caelestia
git checkout -b local/agenda
git am ~/Projects/System/diesel-setup/caelestia/patches/*.patch
```

## Update

```sh
cd ~/.config/quickshell/caelestia
git fetch --tags
git rebase v2.6.0          # new upstream tag
~/Projects/System/diesel-setup/backup.sh   # re-export patches and refresh backup
```

If a patch conflicts, resolve it in the local checkout, finish the rebase, then
run `backup.sh`. Conflicts are normally limited to:

- `modules/dashboard/Content.qml`
- `modules/Shortcuts.qml`
- `modules/nexus/pages/panels/DashboardPanel.qml`
- `modules/bar/Bar.qml`

The `Agenda` tab, service and clock popout are new files and normally do not
conflict.
