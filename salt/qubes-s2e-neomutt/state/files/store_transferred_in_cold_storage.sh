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
set -x

main() {
    # Enable nullglob so the loop skips if empty
    shopt -s nullglob
    # Create cold storage folder
    mkdir -p /home/user/mail/cold_storage
    for VM in /home/user/QubesIncoming/*; do
        for file in "${VM%/}"/*; do
            echo "Processing ${file} files"
            # Rsync files and then remove empty directories
            # rsync can resume interrupted transfers and will only delete files that were fully and correctly copied.
            # && Command deletes the empty directories that remain
            rsync -av --remove-source-files \
                  "${file%/}/" /home/user/mail/cold_storage/ \
                && find "${file%/}" -type d -empty -delete
        done
    done
    notmuch new
}


cleanup() {
    # put cleanup needs here
    exit 0
}

trap 'cleanup' EXIT

main
