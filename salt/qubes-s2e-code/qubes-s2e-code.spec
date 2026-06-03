Name:           qubes-s2e-code
Version:        0.0.1
Release:        1%{?dist}
Summary:        A Salt formula that <DOES A THING> in Qubes OS

License:        GPLv3
URL:            https://github.com/seamustuohy/s2e-qubes-salt
Source0:        %{name}-%{version}.tar.gz

#BuildArch: If the package is not architecture dependent, for example, if written entirely in an interpreted programming language, set this to BuildArch: noarch
BuildArch:      noarch

Requires:       qubes-s2e-common
Requires:       qubes-s2e-desk

%description
A Salt formula that acts as a base for coding qubes

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
/srv/user_salt/qubes-s2e-code
/srv/user_salt/qubes-s2e-code.top
# /srv/salt/_tops/user/qubes-s2e-code.top # It's just a symlink created by top.enable

%post
if [ $1 -eq 1 ]; then
    ## Install
    # https://docs.fedoraproject.org/en-US/packaging-guidelines/Scriptlets/#Syntax
    echo "Installing..."
elif [ $1 -gt 1 ] ; then
    ## Upgrade
    echo "Upgrading..."
    true
fi
VER=$(qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
qubesctl top.enable qubes-s2e-code

qubesctl state.apply qubes-s2e-code.clone  saltenv=user -l debug
qubesctl state.apply qubes-s2e-code.scripts  saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-code-${VER} state.apply common.python3-base-max saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-code-${VER} state.apply qubes-s2e-code.install saltenv=user -l debug

# Disposable PyCode Qubes
qubesctl --skip-dom0 --targets=disp-py-code state.apply common.python_linters saltenv=user -l debug

# If this is not a universal state that will apply to future VMs you want to disable it now
qubesctl top.disable qubes-s2e-code

# Disable after uninstalling (use preun for before)
%postun
if [ $1 -eq 1 ]; then
    qubesctl top.disable qubes-s2e-code
    # Remove cache in case uninstall is because of install failure
    rm -fr /var/cache/salt/minion/files/user/qubes-s2e-code
fi

%changelog
* Sun Oct 19 2025 Seamus Tuohy <code@seamustuohy.com>
- Initial setup
