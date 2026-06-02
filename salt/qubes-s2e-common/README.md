# QUBES-S2E-COMMON

This is the place where I put all my generalized salt configurations which I use in other places.

## Usage

# Update yt-dl packages

Run in the development/builder VM (not dom0)
```
[rpmdev]$ make all
```

# Update docker and mozilla keys
Run in the development/builder VM (not dom0)
```
[rpmdev]$ cd state/files
[rpmdev]$ ./refresh_keys.sh
```

# Install

Example run in the dom0 terminal
```
[dom0]$ sudo qubesctl top.enable qubes-s2e-common
[dom0]$ sudo qubesctl --skip-dom0 --show-output --templates state.apply common.disk_trimming
```

# License

Please see the [license file](./LICENSE) for license information. If you have further questions related to licensing PLEASE create an issue about it on github.
