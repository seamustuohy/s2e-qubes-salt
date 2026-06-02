#!/usr/bin/env bash
#
# Copyright 2024 seamus tuohy, <code@seamustuohy.com>
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

readonly PROG_DIR=$(readlink -m $(dirname $0))
# readonly PROGNAME="$( cd "$( dirname "BASH_SOURCE[0]" )" && pwd )"

test_key() {
    KEYFILE="$1"
    FINGERPRINT="$1"
    gpg -n -q --import --import-options import-show "${KEYFILE}" | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == $FINGERPRINT) error = 0; else error = 1} END {exit err}'
}

cleanup() {
    # put cleanup needs here
    exit 0
}
trap 'cleanup' EXIT

# Firefox Key
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /tmp/packages.mozilla.org.asc > /dev/null
test_key "/tmp/packages.mozilla.org.asc" "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3" && mv "/tmp/packages.mozilla.org.asc" "${PROG_DIR}/packages.mozilla.org.asc"  || echo "Key does not match accepted fingerprint. Not replacing."

# Docker Key
wget -q https://download.docker.com/linux/ubuntu/gpg -O- | tee /tmp/docker-key.gpg > /dev/null
test_key "/tmp/docker-key.gpg" "9DC858229FC7DD38854AE2D88D81803C0EBFCD88" && mv "/tmp/docker-key.gpg" "${PROG_DIR}/docker-key.gpg"  || echo "Key does not match accepted fingerprint. Not replacing."
