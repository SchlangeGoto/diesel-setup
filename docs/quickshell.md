# Quickshell rebuild

`quickshell-git` on this machine was built against Qt 6.11.2 while the system
now provides Qt 6.12.0. Quickshell warns that it must be rebuilt.

## Recommended

Wait for the next Caelestia/Quickshell package build if you want to avoid
mixing a new Quickshell with the current Caelestia 2.5.0.

## Manual rebuild

```sh
yay -S --rebuild quickshell-git
caelestia shell -r
```

Check the new version first:

```sh
pacman -Q quickshell-git
```

The AUR package may move to a newer Quickshell commit. If Caelestia fails after
the upgrade, roll back with Timeshift/btrfs or reinstall the matching Caelestia
build.

## Current versions

```text
quickshell-git 0.3.1.r14.gc6a5160-1
caelestia-shell 2.5.0-1
Qt 6.12.0
```
