Name:           qubes-s2e-dom0
Version:        0.0.2
Release:        1%{?dist}
Summary:        A Salt formula that sets up dom0 in Qubes OS for s2e's devices

License:        GPLv3
URL:            https://github.com/seamustuohy/s2e-qubes-salt
Source0:        %{name}-%{version}.tar.gz

#BuildArch: If the package is not architecture dependent, for example, if written entirely in an interpreted programming language, set this to BuildArch: noarch
BuildArch:      noarch

# REQUIREMENTS (other package names)
# Requires:       qubes-s2e-common

%description
A Salt formula that sets up dom0 in Qubes OS for s2e's devices

#prep: Command or series of commands to prepare the software to be built, for example, unpacking the archive in Source0. This directive can contain a shell script.
%prep
%setup -q

# Command or series of commands for actually building the software into machine code (for compiled languages) or byte code (for some interpreted languages).
# %build
# make update

%pre
if [ $1 -eq 1 ]; then
    echo "First install. Enabling user dirs"
    qubesctl state.sls qubes.user-dirs
elif [ $1 -gt 1 ] ; then
    ## Upgrade
    echo "Upgrading..."
    true
fi

#build: Command or series of commands for copying the desired build artifacts from the %builddir (where the build happens) to the %buildroot directory (which contains the directory structure with the files to be packaged).
%install
rm -rf %{buildroot}/
make install DESTDIR=%{buildroot}

# The list of files that will be installed in the end user’s system. (Only need to identify top level directories to claim all underneath them.)
%files
%license LICENSE
%doc README.md
/srv/user_salt/qubes-s2e-dom0
/srv/user_salt/qubes-s2e-dom0.top
/srv/user_pillar/dom0
# /srv/salt/_tops/user/qubes-s2e-dom0.top # It's just a symlink created by top.enable

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
qubesctl top.enable qubes-s2e-dom0
# TODO -> IMPORTANT. Change <TEMPLATE-TARGET> & <APPVM-TARGET> if using this
qubesctl --targets=dom0 state.highstate  -l debug
# qubesctl --targets=<APPVM-TARGET> state.highstate
# If this is not a universal state that will apply to future VMs you want to disable it now

echo "Installing required templates. This may take a while..."
DEBVER=$(qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
FEDVER=$(qubesctl pillar.get os:template:base_version:fedora --out=txt | awk '{print $NF}')
qvm-template --yes install "debian-${DEBVER}"
qvm-template --yes install "debian-${DEBVER}-minimal"
qvm-template --yes install "fedora-${FEDVER}"
qvm-template --yes install "fedora-${FEDVER}-minimal"

# Update all templates so that we don't have to worry about updating all the ones we are about to make
qubes-vm-update -T --show-output

# Don't disable dom0. You need it!
# qubesctl top.disable qubes-s2e-dom0


# Disable after uninstalling (use preun for before)
%postun
if [ $1 -eq 1 ]; then
    echo "Not disabling dom0. Because that would be silly."
    qubesctl top.disable qubes-s2e-dom0
    if [[ $(md5sum "/srv/user_pillar/top.sls") = "ca2890d3bbd0cc2e344e31904494866f" ]]; then
        rm /srv/user_pillar/top.sls
    else
        sed -i '/^  - dom0.default$/d' "/srv/user_pillar/top.sls"
    fi
fi

%changelog
* Tue Jun 02 2026 Seamus Tuohy <code@seamustuohy.com>
- Fixed autostart scripts
* Sat Oct 25 2025 Seamus Tuohy <code@seamustuohy.com>
- Initial setup
