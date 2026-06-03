Name:           qubes-s2e-desk
Version:        0.0.1
Release:        1%{?dist}
Summary:        A Salt formula that <DOES A THING> in Qubes OS

License:        GPLv3
URL:            https://github.com/seamustuohy/s2e-qubes-salt
Source0:        %{name}-%{version}.tar.gz

#BuildArch: If the package is not architecture dependent, for example, if written entirely in an interpreted programming language, set this to BuildArch: noarch
BuildArch:      noarch

Requires:       qubes-s2e-common

%description
A Salt formula that creates my primary workspaces in Qubes OS

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
/srv/user_salt/qubes-s2e-desk
/srv/user_salt/qubes-s2e-desk.top
# /srv/salt/_tops/user/qubes-s2e-desk.top # It's just a symlink created by top.enable

%pre
if [ $1 -eq 1 ]; then
    echo "Install Pre"
elif [ $1 -eq 2 ]; then
    echo "Transferring all AppVM's to baseline template"
    VER=$(qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
    qvm-shutdown studio || true
    qvm-prefs studio template debian-${VER} || true
    qvm-shutdown personal-desk || true
    qvm-prefs personal-desk template debian-${VER} || true
    qvm-shutdown work-desk || true
    qvm-prefs work-desk template debian-${VER} || true
fi


%post
VER=$(qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
if [ $1 -eq 1 ]; then
    set -x
    ## Install
    echo "Installing..."
    # Clear Cache
elif [ $1 -gt 1 ] ; then
    ## Upgrade
    echo "Transferring all AppVM's back to appropriate templates"
    qvm-prefs studio template tpl-studio-${VER} || true
    qvm-prefs personal-desk template tpl-wkspc-${VER} || true
    qvm-prefs work-desk template tpl-wkspc-${VER} || true
fi
qubesctl top.enable qubes-s2e-desk

# DESK BASE
qubesctl state.apply qubes-s2e-desk.base_clone saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-base-${VER} state.apply common.term-base saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-base-${VER} state.apply common.net-utils  saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-base-${VER} state.apply common.sys-utils  saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-base-${VER} state.apply common.emacs  saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-base-${VER} state.apply common.file-management saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-base-${VER} state.apply common.file-view-and-mod saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-base-${VER} state.apply common.file-examine saltenv=user -l debug

# DESK
qubesctl state.apply qubes-s2e-desk.desk_clone saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-desk-${VER} state.apply common.firefox saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-desk-${VER} state.apply common.gnome-settings saltenv=user -l debug

# ALL Working Spaces
qubesctl state.apply qubes-s2e-desk.working_spaces_clone saltenv=user -l debug

# Studio Desks
qubesctl --skip-dom0 --targets=tpl-studio-${VER} state.apply common.tex saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-studio-${VER} state.apply common.design saltenv=user -l debug

# Work Desks
qubesctl --skip-dom0 --targets=tpl-wkspc-${VER} state.apply common.tex saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-wkspc-${VER} state.apply common.timewarrior saltenv=user -l debug
qubesctl --skip-dom0 --targets=tpl-wkspc-${VER} state.apply common.python3-base-max saltenv=user -l debug

# App VMs
qubesctl --skip-dom0 --targets=work-desk state.apply common.python_linters saltenv=user -l debug
qubesctl --skip-dom0 --targets=personal-desk state.apply common.python_linters saltenv=user -l debug

# This will fail until you first run libreoffice. So, you will need to run it again
qubesctl --skip-dom0 --targets=work-desk state.apply common.libreoffice-appvm saltenv=user -l debug || true
qubesctl --skip-dom0 --targets=personal-desk state.apply common.libreoffice-appvm saltenv=user -l debug || true

# qubesctl --skip-dom0 --targets=work-desk state.highstate saltenv=user -l debug
# qubesctl --skip-dom0 --targets=personal-desk state.highstate saltenv=user -l debug
# qubesctl --skip-dom0 --targets=studio state.highstate saltenv=user -l debug
# If this is not a universal state that will apply to future VMs you want to disable it now
qubesctl top.disable qubes-s2e-desk

# Disable after uninstalling (use preun for before)
%postun
if [ $1 -eq 1 ]; then
    qubesctl top.disable qubes-s2e-desk
    # Remove cache in case of install failure
    rm -fr /var/cache/salt/minion/files/user/qubes-s2e-desk
fi

%changelog
* Sun Oct 19 2025 Seamus Tuohy <code@seamustuohy.com>
- Initial setup
