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
        echo "Error: You must provide a name for the new VM as the first command line arg."
        exit 1
    fi
    VER=$(sudo qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
    sudo qvm-create "${VMNAME}" \
               --template=tpl-qubes-s2e-neomutt-${VER} \
               --prop=audiovm="" \
               --prop=netvm='sys-firewall' \
               --prop=include-in-backups=false \
               --prop=memory=200 \
               --prop=maxmem=350 \
               --prop=label=red \
               --prop=vcpus=1
    sudo qvm-tags "${VMNAME}" add neomutt-vm
    sudo qvm-service --enable"${VMNAME}" crond
    sudo qubesctl top.enable qubes-s2e-neomutt
    sudo qubesctl --skip-dom0 --show-output --targets="${VMNAME}" state.apply qubes-s2e-neomutt.install saltenv=user #-l debug
    sudo qubesctl --skip-dom0 --show-output --targets="${VMNAME}" state.apply qubes-s2e-neomutt.configure saltenv=user #-l debug
    sudo qubesctl --skip-dom0 --show-output --targets="${VMNAME}" state.apply qubes-s2e-neomutt.cron_appvm saltenv=user  #-l debug
    sudo qubesctl top.disable qubes-s2e-neomutt
}

cleanup() {
    # put cleanup needs here
    sudo qubesctl top.disable qubes-s2e-neomutt
    exit 0
}

trap 'cleanup' EXIT


main "${1}"
