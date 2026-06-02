#!/usr/bin/env bash
#
# This file is part of s2e's qubes files.
# Copyright ©2025 seamus tuohy, <code@seamustuohy.com>
# Builds on qusal-send-inbox: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
## SPDX-License-Identifier: AGPL-3.0-or-later
## https://github.com/ben-grande/qusal/blob/bcea67d353902c3cc649e7b029ecd48c78e90bd2/salt/mail/files/fetcher/bin/qusal-send-inbox

# For guidance on how it works see: https://github.com/holiman/qvm-sync/blob/4ee942c18366972983495028e5733dd5c42567a4/README.md?plain=1#L34

# Setup
#Bash should terminate in case a command or chain of command finishes with a non-zero exit status.
#See: https://github.com/azet/community_bash_style_guide#style-conventions
set -e

main() {
    RPM_DIR=$(realpath "${1}")
    RPM_DIR_NAME=$(basename "${RPM_DIR}")
    if test ! -d "${RPM_DIR}"; then
        printf '%s\n' "RPM Directory '${RPM_DIR}' does not exist or is not a directory" >&2
        exit 1
    fi
    # `find` spec file. Extract info. -quit after first exec.
    FOUND_PACKAGE_NAME=$(find "${RPM_DIR}" -type f -name "*.spec" -exec grep "Name:" {} \; -quit | cut -d : -f 2 | tr -d [:space:])
    FOUND_VERSION_NUM=$(find "${RPM_DIR}" -type f -name "*.spec" -exec grep "Version:" {} \; -quit | cut -d : -f 2 | tr -d [:space:])
    # Defaults to package info from spec if not identified
    PACKAGE_NAME="${2:-$FOUND_PACKAGE_NAME}"
    VERSION_NUM="${3:-$FOUND_VERSION_NUM}"
    PARENT_DIR=$(dirname "${RPM_DIR}")
    cd  "${PARENT_DIR}"
    rm -fr /tmp/rpmpackage
    mkdir -p /tmp/rpmpackage
    tar czf /tmp/rpmpackage/${PACKAGE_NAME}-${VERSION_NUM}.tar.gz -C "${PARENT_DIR}" "${RPM_DIR_NAME}" --transform s/"${RPM_DIR_NAME}"/${PACKAGE_NAME}-${VERSION_NUM}/
    cp "${RPM_DIR}/Makefile" /tmp/rpmpackage/.
    cp "${RPM_DIR}"/*.spec /tmp/rpmpackage/.

    qrexec-client-vm --filter-escape-chars-stderr -- @dispvm:rpmbuild-dispvm qubes.RpmBuild \
                     /usr/lib/qubes/qfile-agent /tmp/rpmpackage
}

cleanup() {
    # put cleanup needs here
    exit 0
}

trap 'cleanup' EXIT

# USAGE ./send-rpmbuild.sh "RPM/PROJECT/FOLDER/PATH" "qubes-s2e-NAME" "0.0.1"
main "${1}" "${2}" "${3}"
