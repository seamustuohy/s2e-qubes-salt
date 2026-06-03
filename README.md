# s2e-qubes-salt

Saltstack setup scripts for s2e's QubesOS computer.

## Firstboot Install

### Update dom0 to ensure DNF will run correctly.
```shell_session
[dom0]$ sudo qubes-dom0-update
```

### Copy over rpm's
Attach USB with rpm's to the auto-created `personal` qube then copy them over to dom0.
```shell_session
[dom0]$ qvm-run --pass-io personal 'cat /media/user/files/qubes-s2e-dom0.rpm' > /tmp/qubes-s2e-dom0.rpm
[dom0]$ qvm-run --pass-io personal 'cat /media/user/files/qubes-s2e-common.rpm' > /tmp/qubes-s2e-common.rpm
[dom0]$ qvm-run --pass-io personal 'cat /media/user/files/qubes-s2e-desk.rpm' > /tmp/qubes-s2e-desk.rpm
[dom0]$ qvm-run --pass-io personal 'cat /media/user/files/qubes-s2e-code.rpm' > /tmp/qubes-s2e-code.rpm
[dom0]$ qvm-run --pass-io personal 'cat /media/user/files/qubes-s2e-dotfiles.rpm' > /tmp/qubes-s2e-dotfiles.rpm
[dom0]$ qvm-run --pass-io personal 'cat /media/user/files/qubes-s2e-rpmbuild.rpm' > /tmp/qubes-s2e-rpmbuild.rpm
[dom0]$ qvm-run --pass-io personal 'cat /media/user/files/qubes-s2e-neomutt.rpm' > /tmp/qubes-s2e-neomutt.rpm
```

### Install RPM's (in this order)
```shell_session
[dom0]$ sudo dnf install /tmp/qubes-s2e-dom0.rpm
[dom0]$ sudo dnf install /tmp/qubes-s2e-common.rpm
[dom0]$ sudo dnf install /tmp/qubes-s2e-desk.rpm
[dom0]$ sudo dnf install /tmp/qubes-s2e-code.rpm
[dom0]$ sudo dnf install /tmp/qubes-s2e-dotfiles.rpm
[dom0]$ sudo dnf install /tmp/qubes-s2e-rpmbuild.rpm
[dom0]$ sudo dnf install /tmp/qubes-s2e-neomutt.rpm
```

### Debugging the Install
If you need to get debug logging you can add the following flags..
```shell_session
[dom0]$ sudo dnf install /tmp/qubes-s2e-XXXXX.rpm --setopt=rpmverbosity=debug
```

Then in a secondary dom0 terminal
```shell_session
tail -f /var/log/dnf5.log
```


## Using the RPM Builder

The qubes-s2e-rpmbuild package auto-creates an AppVM for building packages (qubes-salt-dev). You can use that to edit the files in this repo and pull them with your dom0 qube.

If you want to add the ability to pull from another AppVM you can use the `qvm-install_rpmbuild_on_qube` script added to dom0 by the qubes-s2e-rpmbuild package to allow another AppVM to be used by Dom0 for building packages.


First, make sure your AppVM is using a template that you want to install send-rpmbuild script on.
```shell_session
[dom0]$ qvm-clone qvm.clone "debian-12" "tpl-rpmdev-12"
[dom0]$ qvm-create --class AppVM --template "tpl-rpmdev-12" RpmDevVMName
```
Then, use the script to setup your AppVM and its template.
```shell_session
[dom0]$ qvm-install_rpmbuild_on_qube RpmDevVMName
```

# Debugging

## Run debug on qubesctl commands
Just put `-l debug` at the end of the command
```shell_session
[dom0]$ sudo qubesctl --skip-dom0 --show-output --targets=TARGET state.apply qubes-s2e-NAME.install saltenv=user -l debug
```

## Even MOAR debugging on qubesctl commands
You can also set logging at the trace level which provides logging for internal functions and module loads
```shell_session
[dom0]$ sudo qubesctl --skip-dom0 --show-output --targets=TARGET state.apply qubes-s2e-NAME.install saltenv=user -l trace
```

### Full Available Log Levels

In descending order of verbosity:

- all
- garbage
- trace (Highly granular; traces internal functions and module loads)
- debug (General debugging data)
- profile
- info
- warning
- error
- critical
- quiet


## What salt modules are available on Qubes?

You're trying to run some salt module but it doesn't look like it exists? Just run the following command in Dom0 to see the modules available to you.

```shell_session
[dom0]$ sudo salt-call --local sys.list_modules
```

## What salt function are available in a module?
You're trying to run some function in a salt module but it fails saying that "Reason: `module_name.function_name` is not available."
Just run the following command in Dom0 to see that module actually has the function you are using.

```shell_session
[dom0]$ sudo salt-call --local sys.list_functions file
```

## What stat files are available on Qubes?
List enabled state files (located within `/srv/salt/_tops**` and `/srv/pillar/_tops**`). `top.disabled` to list disabled, not activated states. `top.is_enabled` to list both.

```shell_session
[dom0]$ sudo qubesctl top.enabled
```

## Something is wrong with the salt code that is running.
Sync all modules.  If a problem exists, one may remove the salt cache directory (`rm -r /var/cache/salt`) and re-sync the modules
```shell_session
[dom0]$ rm -r /var/cache/salt
[dom0]$ qubesctl saltutil.sync_all
```

## List the pillar items for a specific minion
```shell_session
[dom0]$ sudo qubesctl --show-output --skip-dom0 --targets="${TARGET}" pillar.items
```

## Show the rendered output of an SLS file

To display the rendered output of a Salt SLS file without applying it, you can use the state.show_sls command. This command is executed on the Salt master and allows you to preview the high data structure that Salt generates after rendering the SLS file, including any Jinja templating, Pillar data, and Grains. (Use -l debug to find errors in its rendering)

```shell_session
[dom0]$ sudo qubesctl --show-output --targets='<target_minion_id>' state.show_sls <sls_file_name> -l debug
```

## Install Issues

## You are getting an error with a module or salt code that you don't think should be there.
Sync all modules.  If a problem exists, one may remove the salt cache directory (`rm -r /var/cache/salt`) and re-sync the modules
```shell_session
[dom0]$ rm -r /var/cache/salt
[dom0]$ qubesctl saltutil.sync_all
```

### It didn't run the salt code changes you included in an rpm package

You just need to delete the salt cache so it uses the updated salt files.

```shell_session
[dom0]$ rm -fr /var/cache/salt/minion/files/user/qubes-s2e-NAME
```

## See CPU/Mem usage across all qubes from the dom0 command line

```shell_session
[dom0]$ xentop -f
```


# LICENSE
Copyright © 2024 Seamus Tuohy

This project is released under the GNU General Public License v3 (see [LICENSE](LICENSE)).

# ATTRIBUTION
- This code-base built on and adapted a good deal of insights, structure, and code from `User Salt Formulas for Qubes OS` (Copyright © 2021 Gonzalo Bulnes Guilpain).
