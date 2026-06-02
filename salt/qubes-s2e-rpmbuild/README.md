# QUBES-S2E-RPMBUILD

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

## Creating Salt Packages in a disposable DevVM by hand
**NOTE: You don't need to do this. Just use send-rpmbuild.**

### Update any Binaries

In development VM <DEV_VM> run the makefile to update and verify any binaries which are needed.
```shell_session
make update-binaries
```

### Create rpm package

In development VM <DEV_VM> run the makefile to create tar source blob and then move it, makefile, and spec over to the build VM <RPM_VM>.
```shell_session
make prep-rpm-dev-vm
```

In the build VM <RPM_VM> run the makefile in the QubesIncoming folder to build.
```shell_session
cd ~/QubesIncoming/<DEV_VM>
make rpmbuild-build-vm
```

# License

Please see the [license file](./LICENSE) for license information. If you have further questions related to licensing PLEASE create an issue about it on github.
