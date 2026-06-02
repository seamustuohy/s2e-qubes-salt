Name:           qubes-s2e-NAME
Version:        0.0.1
Release:        1%{?dist}
Summary:        A Salt formula that <DOES A THING> in Qubes OS

License:        GPLv3
URL:            https://github.com/seamustuohy/s2e-qubes-salt
Source0:        %{name}-%{version}.tar.gz

#BuildArch: If the package is not architecture dependent, for example, if written entirely in an interpreted programming language, set this to BuildArch: noarch
BuildArch:      noarch

# REQUIREMENTS (other package names)
# Requires:       qubes-s2e-common

%description
A Salt formula that <DOES A THING> in Qubes OS

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
/srv/user_salt/qubes-s2e-NAME
/srv/user_salt/qubes-s2e-NAME.top
# /srv/salt/_tops/user/qubes-s2e-NAME.top # It's just a symlink created by top.enable

%pre
if [ $1 -eq 1 ]; then
    echo "Install Pre-scriptlet"
elif [ $1 -eq 2 ]; then
    echo "Upgrade/reinstall Pre-scriptlet"
    rm -fr /var/cache/salt/minion/files/user/qubes-s2e-NAME
fi

%post
# 1a. Extract DNF/RPM verbosity flags passed from the CLI
# Checking for -v, -vv, or explicit --rpmverbosity debug modes
# Results will be:
# - RPM_VERBOSITY=--rpmverbosity=debug
# - RPM_VERBOSITY=-vvvvv
# - etc...
RPM_VERBOSITY=$(ps -o args= -p $PPID | grep -oE '\-(v+)|(rpmverbosity(=|\s+)(debug|info))' | head -n 1)
# 1b. Apply settings based on verbosity detection
if [ -n "$RPM_VERBOSITY" ]; then
    # NOTE: ${QVM_LOGGING} must not be quoted when used below.
    QVM_LOGGING=""
    # --rpmverbosity=debug or one or more -v flags passed
    # https://knowledge.broadcom.com/external/article/320601/how-to-enable-debug-logging-on-saltstack.html
    if [[ "$RPM_VERBOSITY" == *"vvv"* ]]; then
        echo "[DEBUG+TRACE] Verbose DNF/RPM flag detected: $RPM_VERBOSITY"
        # Enable bash execution tracing so every command is logged to stdout/file
        set -x
        # NOTE: ${QVM_LOGGING} must not be quoted when used below.
        QVM_LOGGING="-l trace"
    elif [[ "$RPM_VERBOSITY" == *"debug"* || "$RPM_VERBOSITY" == *"vv"* ]]; then
        echo "[DEBUG] Verbose DNF/RPM flag detected: $RPM_VERBOSITY"
        # NOTE: ${QVM_LOGGING} must not be quoted when used below.
        QVM_LOGGING="-l debug"
    elif [[ "$RPM_VERBOSITY" == *"info"* || "$RPM_VERBOSITY" == *"v"* ]]; then
        echo "[INFO] Verbose DNF/RPM flag detected: $RPM_VERBOSITY"
        # NOTE: ${QVM_LOGGING} must not be quoted when used below.
        QVM_LOGGING="-l info"
    fi
else
    # Standard installation, keep output minimal
    echo "Non-Verbose Install Started"
fi
# 2. RUN separate Install vs. Reinstall/Upgrade scripts
if [ $1 -eq 1 ]; then
    ## Install
    echo "Installing..."
elif [ $1 -gt 1 ] ; then
    ## Upgrade
    echo "Upgrading/ReInstalling..."
fi
# 3. RUN all purpose scripts for Install, Reinstall, and Upgrade states
# https://docs.fedoraproject.org/en-US/packaging-guidelines/Scriptlets/#Syntax
set -x
echo "Installing..."
VER=$(qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
qubesctl top.enable qubes-s2e-NAME

## TODO -> IMPORTANT. Change <TEMPLATE-TARGET> & <APPVM-TARGET> if using this

## CLONE TEMPLATES
# qubesctl state.apply qubes-s2e-NAME.clone saltenv=user  # -l debug
# Config Templates
# qubesctl --skip-dom0 --show-output --targets=<TEMPLATE-TARGET>-${VER} state.apply qubes-s2e-NAME.install saltenv=user ${QVM_LOGGING}
# qubesctl --skip-dom0 --show-output --targets=<TEMPLATE-TARGET>-${VER} state.apply qubes-s2e-NAME.configure saltenv=user ${QVM_LOGGING}

## AppVM Scripts
# qubesctl --skip-dom0 --show-output --targets=<APPVM-TARGET> state.apply qubes-s2e-NAME.install saltenv=user ${QVM_LOGGING}
# qubesctl --skip-dom0 --show-output --targets=<APPVM-TARGET> state.apply qubes-s2e-NAME.configure saltenv=user ${QVM_LOGGING}


## If this is not a universal state that will apply to future VMs you want to disable it now
# qubesctl top.disable qubes-s2e-NAME



# Disable after uninstalling (use preun for before)
%postun
set +x # Remove tracing just in case we set it with debug.
if [ $1 -eq 1 ]; then
    qubesctl top.disable qubes-s2e-NAME
    # Remove cache in case uninstall is because of install failure
    rm -fr /var/cache/salt/minion/files/user/qubes-s2e-NAME
fi

%changelog
* DAY MON XX 20XX Seamus Tuohy <code@seamustuohy.com>
- Initial setup
