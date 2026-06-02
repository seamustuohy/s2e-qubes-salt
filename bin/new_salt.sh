#!/usr/bin/env bash
#
# This file is part of s2e-qubes, a setup codebase for a qubes system.
# Copyright © 2023 seamus tuohy, <code@seamustuohy.com>
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
#Terminate the script in case an uninitialized variable is accessed.
#See: https://github.com/azet/community_bash_style_guide#style-conventions
set -u
# set -x

main() {
    formula_name=${1}
    mkdir "salt/${formula_name}"
    mkdir "salt/${formula_name}/state"
    cat "templates/package/Makefile" | sed "s/qubes-s2e-NAME/${formula_name}/" > "salt/${formula_name}/Makefile"
    cat "templates/package/qubes-s2e-NAME.spec" | sed "s/qubes-s2e-NAME/${formula_name}/" > "salt/${formula_name}/${formula_name}.spec"
    cp -fr templates/tpl-TEST/* "salt/${formula_name}/."
    mv "salt/${formula_name}/tpl-TEST.top" "salt/${formula_name}/${formula_name}.top"
    find "salt/${formula_name}/." -type f -exec sed -i "s/tpl-TEST/${formula_name}/g" {} \;
    echo "New salt base can be found at: salt/${formula_name}"
}

cleanup() {
    # put cleanup needs here
    exit 0
}

trap 'cleanup' EXIT

main ${1}
