Name:           qubes-s2e-neomutt
Version:        0.0.1
Release:        1%{?dist}
Summary:        A Salt formula that sets up email in Qubes OS

License:        GPLv3
URL:            https://github.com/seamustuohy/s2e-qubes-salt
Source0:        %{name}-%{version}.tar.gz

#BuildArch: If the package is not architecture dependent, for example, if written entirely in an interpreted programming language, set this to BuildArch: noarch
BuildArch:      noarch

%description
A Salt formula that sets up email in Qubes OS

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
/srv/user_salt/qubes-s2e-neomutt
/srv/user_salt/qubes-s2e-neomutt.top
# /srv/salt/_tops/user/qubes-s2e-email.top # It's just a symlink created by top.enable

%post
if [ $1 -eq 1 ]; then
    VER=$(qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
    qubesctl top.enable qubes-s2e-neomutt

    # CLONE TEMPLATES
    qubesctl state.apply qubes-s2e-neomutt.clone saltenv=user  #-l debug
    # CONFIG DOM0
    qubesctl --targets=dom0 state.apply  qubes-s2e-neomutt.rpc saltenv=user  #-l debug
    qubesctl --targets=dom0 state.apply  qubes-s2e-neomutt.mailvm_scripts saltenv=user # -l debug
    # TEMPLATE INSTALL
    qubesctl --skip-dom0 --show-output --targets=tpl-qubes-s2e-neomutt-${VER} state.apply qubes-s2e-neomutt.install saltenv=user #-l debug
    qubesctl --skip-dom0 --show-output --targets=tpl-qubes-s2e-neomutt-CS-${VER} state.apply qubes-s2e-neomutt.install saltenv=user #-l debug
    # COLD STORAGE APP-VM
    qubesctl --skip-dom0 --show-output --targets=mail-cold-storage state.apply qubes-s2e-neomutt.configure saltenv=user #-l debug
    qubesctl --skip-dom0 --show-output --targets=mail-cold-storage state.apply qubes-s2e-neomutt.cron_cold_storage saltenv=user  #-l debug
    # APP VM INSTALLS
    MAILVMS=$(qvm-ls --tags neomutt-vm --raw-data --fields name | tr '\n' ',' | sed 's/,$//')
    if [ -n "${MAILVMS// }" ]; then
        echo "Running install/configure on the following AppVMs: ${MAILVMS// }"
        qubesctl --skip-dom0 --show-output --targets="${MAILVMS}" state.apply qubes-s2e-neomutt.install saltenv=user #-l debug
        qubesctl --skip-dom0 --show-output --targets="${MAILVMS}" state.apply qubes-s2e-neomutt.configure saltenv=user #-l debug
        echo "Applying cron to mail AppVMs."
        qubesctl --skip-dom0 --show-output --targets="${MAILVMS}" state.apply qubes-s2e-neomutt.cron_appvm saltenv=user  #-l debug
    else
        echo "No existing mail AppVMs found. Not adding cron."
    fi
    qubesctl top.disable qubes-s2e-neomutt

    echo "FIRST BOOT PROTOCOL"
    echo "Setup lieer in SEPARATE browser connected system then copy over ~/mail directory"
    echo " - create app"
    echo " - get client_secret.json"
    echo " - \$ mkdir ~/mail"
    echo " - \$ mv client_secret.json ~/mail/."
    echo " - \$ cd ~/mail/"
    echo " - \$ notmuch new"
    echo " - \$ gmi init -c client_secret.json email@email.com"
    echo " - \$ gmi pull"
    echo " - Once it fails... resume"
    echo " - \$ gmi pull --resume"
    echo "import or create blank blocked list: "
    echo "\$ touch /home/user/.config/afew/blocked.lsv"
    echo "import or create blank contacts list: "
    echo "\$ touch /home/user/.contacts.org"
    echo "run a test afew to check config"
    echo " - \$ afew  -vv --tag --new --dry-run "
fi

# Disable after uninstalling (use preun for before)
%preun
if [ $1 -eq 1 ]; then
    qubesctl top.disable qubes-s2e-neomutt
    # Remove cache in case of install failure
    rm -fr /var/cache/salt/minion/files/user/qubes-s2e-neomutt
fi

%changelog
* Wed Jun 04 2025 Seamus Tuohy <code@seamustuohy.com>
- Initial setup
