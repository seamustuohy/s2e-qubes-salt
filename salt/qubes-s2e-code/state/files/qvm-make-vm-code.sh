#!/usr/bin/env bash
#
# Copyright © 2026 seamus tuohy, <code@seamustuohy.com>
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
set -x

main() {
    VMNAME="${1}"
    if [[ -z "$VMNAME" ]]; then
        echo "Error: You must provide a name for the code project VM as the first command line arg."
        exit 1
    fi
    VER=$(sudo qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
    sudo qvm-create "${VMNAME}" \
               --template=tpl-code-${VER} \
               --prop=audiovm="" \
               --prop=netvm='sys-firewall' \
               --prop=memory=5000 \
               --prop=maxmem=5000 \
               --prop=label=green \
               --prop=vcpus=3
    sudo qvm-prefs "${VMNAME}" include_in_backups false
    # Note: You don't need to enable top files to run them with salt.apply
    # Dotfiles
    sudo qvm-tags "${VMNAME}" add "has-dotfiles"
    sudo qubesctl --skip-dom0 --show-output --targets="${VMNAME}" state.apply qubes-s2e-dotfiles.install-appvm saltenv=user -l debug
    # python linters
    sudo qubesctl --skip-dom0 --targets=disp-py-code state.apply common.python_linters saltenv=user -l debug
}

cleanup() {
    # put cleanup needs here
    sudo qubesctl top.disable qubes-s2e-code
    exit 0
}

trap 'cleanup' EXIT


main "${1}"
