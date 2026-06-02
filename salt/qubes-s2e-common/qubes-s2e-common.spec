Name:           qubes-s2e-common
Version:        0.0.1
Release:        1%{?dist}
Summary:        A Salt formula that <DOES A THING> in Qubes OS

License:        GPLv3
URL:            https://github.com/seamustuohy/s2e-qubes-salt
Source0:        %{name}-%{version}.tar.gz

#BuildArch: If the package is not architecture dependent, for example, if written entirely in an interpreted programming language, set this to BuildArch: noarch
BuildArch:      noarch

%description
A series of Salt states that are used for my Qubes OS

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
/srv/user_salt/common
/srv/user_salt/common.top
# /srv/salt/_tops/user/qubes-s2e-common.top # It's just a symlink created by top.enable

%post
if [ $1 -eq 1 ]; then
    ## Install
    qubesctl top.enable common
elif [ $1 -gt 1 ] ; then
    ## Upgrade
    true
fi

# Disable after uninstalling (use preun for before)
%postun
if [ $1 -eq 1 ]; then
    qubesctl top.disable common
    # Remove cache in case uninstall is because of install failure
    rm -fr /var/cache/salt/minion/files/user/common
fi


%changelog
* Sun Oct 19 2025 Seamus Tuohy <code@seamustuohy.com>
- Initial setup
