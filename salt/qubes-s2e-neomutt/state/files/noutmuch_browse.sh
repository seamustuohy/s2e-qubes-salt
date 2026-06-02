#!/usr/bin/env bash
#
# Copyright © Symbol’s function definition is void: end-of-file) seamus tuohy, <code@seamustuohy.com>
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

main() {
    QUERY="${1}"
    notmuch search --output=summary --format=json "$QUERY" | \
        sed 's/\\t/ /g' | \
        jq -r '.[] | [.subject, .authors, .date_relative, .matched, .thread] | @tsv' | \
        fzf -d '\t' \
            --ansi \
            --reverse \
            --gap \
            --wrap \
            --exact \
            --with-nth '{3}: {1}'  \
            --preview "notmuch show {5}" \
            --preview-window=right:60% \
            --no-sort \
            --header "Use Enter to read, Ctrl-C to exit" \
            --bind "enter:execute(notmuch show thread:{})+accept"
}


cleanup() {
    # put cleanup needs here
    exit 0
}

trap 'cleanup' EXIT


main "${1}"
