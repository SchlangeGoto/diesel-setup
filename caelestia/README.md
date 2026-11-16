# Caelestia shell patches

Local Caelestia changes live as patches in `patches/`.

- Base: see `base.txt` (currently `v2.5.0`)
- Last local commit: see `commit.txt`
- Local branch: `local/agenda`
- Upstream: <https://github.com/caelestia-dots/shell>

Apply on a fresh checkout:

```sh
git clone --branch "$(cat caelestia/base.txt)" \
  https://github.com/caelestia-dots/shell.git ~/.config/quickshell/caelestia
cd ~/.config/quickshell/caelestia
git checkout -b local/agenda
git am ~/diesel-setup/caelestia/patches/*.patch
```

See `../docs/caelestia.md` for updating/rebase instructions.
