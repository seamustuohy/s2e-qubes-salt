# tpl-TEST

## Usage

### Build RPM and install on dom0
Note: this will re-install if package is already installed.
```shell_session
[dom0]$ qvm-install-rpm-from-builder [/path/to/rpm/folder/tpl-TEST] [DEVELOPMENT-VM-NAME]
```

### Build RPM and update the package on dom0

Note: if you already have this version of the RPM installed this command will not reinstall the package. This makes it a good script to use to build and deposit a new rpm in the dom0 tmp directory.
```shell_session
[dom0]$ qvm-update-rpm-from-builder [/path/to/rpm/folder/tpl-TEST] [DEVELOPMENT-VM-NAME]
```

### Install the package from Dom0 /tmp/

`sudo dnf install /tmp/[RPM_FILENAME]`

EXAMPLE: `sudo dnf install /tmp/tpl-TEST.rpm`

If you already installed it and its not a new version use reinstall **using the packages file path** in the dom0 terminal
```shell_session
[dom0]$ sudo dnf reinstall /tmp/tpl-TEST.rpm
```

**ISSUE WHEN REINSTALLING: "It didn't accept my changes to the rpm packages salt code?!!?"**
You just need to delete the salt cache so it uses the updated salt files.
```shell_session
[dom0]$ rm -fr /var/cache/salt/minion/files/user/tpl-TEST
```

## Uninstalling
Use DNF to uninstall the package **using its package name** using the dom0 terminal

```shell_session
[dom0]$ sudo dnf remove -v tpl-TEST
```

### Debugging the Install

If you need to get debug logging you can add the following flags..
```shell_session
[dom0]$ sudo dnf install /tmp/tpl-TEST.rpm --setopt=rpmverbosity=debug
```

Then in a secondary dom0 terminal
```shell_session
tail -f /var/log/dnf5.log
```

# License

Please see the [license file](./LICENSE) for license information. If you have further questions related to licensing PLEASE create an issue about it on github.
