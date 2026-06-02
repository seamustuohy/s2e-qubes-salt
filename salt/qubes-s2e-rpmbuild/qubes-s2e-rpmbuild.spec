Name:           qubes-s2e-rpmbuild
Version:        0.0.2
Release:        1%{?dist}
Summary:        A Salt formula that creates a disposable VM for making RPM packages in Qubes OS

License:        GPLv3
URL:            https://github.com/seamustuohy/s2e-qubes-salt
Source0:        %{name}-%{version}.tar.gz

#BuildArch: If the package is not architecture dependent, for example, if written entirely in an interpreted programming language, set this to BuildArch: noarch
BuildArch:      noarch

# Requires:       qubes-s2e-code

%description
A Salt formula that creates a disposable VM for making RPM packages in Qubes OS

#prep: Command or series of commands to prepare the software to be built, for example, unpacking the archive in Source0. This directive can contain a shell script.
%prep
%setup -q

# Command or series of commands for actually building the software into machine code (for compiled languages) or byte code (for some interpreted languages).
# %build
# make update

#build: Command or series of commands for copying the desired build artifacts from the %builddir (where the build happens) to the %buildroot directory (which contains the directory structure with the files to be packaged).
%install
rm -rf %{buildroot}/
make install DESTDIR=%{buildroot}

# The list of files that will be installed in the end user’s system. (Only need to identify top level directories to claim all underneath them.)
%files
%license LICENSE
%doc README.md
/srv/user_salt/qubes-s2e-rpmbuild
/srv/user_salt/qubes-s2e-rpmbuild.top
/etc/qubes/policy.d/40-rpmbuild.policy
# /srv/salt/_tops/user/qubes-s2e-rpmbuild.top # It's just a symlink created by top.enable

%pre
if [ $1 -eq 1 ]; then
    echo "Install Pre"
elif [ $1 -eq 2 ]; then
    echo "Upgrade/reinstall Pre-scriptlet"
    rm -fr /var/cache/salt/minion/files/user/qubes-s2e-rpmbuild
fi


%post
if [ $1 -eq 1 ]; then
    echo "Install Post-scriptlet"
elif [ $1 -eq 2 ]; then
    echo "Upgrade/reinstall Post-scriptlet"
fi
VER=$(qubesctl pillar.get os:template:base_version:fedora --out=txt | awk '{print $NF}')
qubesctl top.enable qubes-s2e-rpmbuild
# Cloning
qubesctl state.apply qubes-s2e-rpmbuild.clone  saltenv=user -l debug
# DOM0 CONFIGURE
qubesctl --show-output --targets=dom0 state.apply qubes-s2e-rpmbuild.dom0-helpers saltenv=user -l debug
# TEMPLATE INSTALL
# qubesctl --skip-dom0 --show-output --targets=template-rpmbuild state.highstate  -l debug
qubesctl --skip-dom0 --show-output --targets=tpl-rpmbuild-${VER} state.apply qubes-s2e-rpmbuild.install saltenv=user #-l debug
qubesctl --skip-dom0 --show-output --targets=tpl-rpmbuild-${VER} state.apply qubes-s2e-rpmbuild.rpc_service saltenv=user #-l debug
echo "Adding RPMDev rpm builder client to all AppVM's with rpmdev tag."
qubesctl --skip-dom0 --show-output --targets="$(qvm-ls --no-spinner --raw-list --tags rpmdev | grep template | tr '\n' ',')" state.apply qubes-s2e-rpmbuild.rpc_client saltenv=user -l debug
qubesctl top.disable qubes-s2e-rpmbuild

# Get all vm's which have the rpmdev tag and have 'template' in the name. Make them a comma separated list
# qvm-ls --no-spinner --raw-list --tags rpmdev | grep template | tr '\n' ','

# Disable after uninstalling (use preun for before)
%postun
if [ $1 -eq 1 ]; then
    qubesctl top.disable qubes-s2e-rpmbuild
    # Remove cache in case of install failure
    rm -fr /var/cache/salt/minion/files/user/qubes-s2e-rpmbuild
fi

%changelog
* Tue May 26 2026 Seamus Tuohy <code@seamustuohy.com>
- Add dom0 directed rpm building

* Wed May 21 2025 Seamus Tuohy <code@seamustuohy.com>
- Initial setup
