#!/usr/bin/env bash
#
# This file is part of qubes-s2e-rpmbuild, a package description short.
# Copyright © 2025 seamus tuohy, <code@seamustuohy.com>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the included LICENSE file for details.

# Setup

#Bash should terminate in case a command or chain of command finishes with a non-zero exit status.
#Terminate the script in case an uninitialized variable is accessed.
#See: https://github.com/azet/community_bash_style_guide#style-conventions
set -e
set -u

# TODO remove DEBUGGING
# set -x

# Read Only variables

# readonly PROG_DIR=$(readlink -m $(dirname $0))
# readonly PROGNAME="$( cd "$( dirname "BASH_SOURCE[0]" )" && pwd )"


## Sets up an AppVM as an rpmdev source OR sets up a template to include the rpmdev client files

main() {
    NAME="${1}"
    CLASS=$(qvm-ls "${NAME}" --fields CLASS --raw-data)
    # Check the class
    if [ "$CLASS" = "AppVM" ]; then
        echo "${NAME} is an AppVM"
        # add tag to allow appvm to use the builder
        echo "adding 'rpmdev' tag to allow appvm to use the builder"
        qvm-tags "${NAME}" add rpmdev
        # Update template to install send-rpmbuild script
        TPL_NAME=$(qvm-ls "${NAME}" --fields TEMPLATE --raw-data)
        echo "Updating template ${TPL_NAME} to install send-rpmbuild script"
        sudo qubesctl --skip-dom0 --show-output --targets="${TPL_NAME}" state.apply qubes-s2e-rpmbuild.rpc_client saltenv=user
    elif [ "$CLASS" = "TemplateVM" ]; then
        echo "${NAME} is a TemplateVM"
        echo "Updating template to install send-rpmbuild script"
        # Update template to install send-rpmbuild script
        sudo qubesctl --skip-dom0 --show-output --targets="${NAME}" state.apply qubes-s2e-rpmbuild.rpc_client saltenv=user
    elif [ "$CLASS" = "DispVM" ]; then
        echo "${NAME} is a Disposable VM"
        echo "This function does not configure custom disposable VM's. You must use the DispVM with the name 'rpmbuild-dispvm' created during initial cloning"
    else
        echo "Unknown class: $CLASS"
        echo "Can't continue"
    fi
}

cleanup() {
    # put cleanup needs here
    exit 0
}

trap 'cleanup' EXIT


main "${1}"
