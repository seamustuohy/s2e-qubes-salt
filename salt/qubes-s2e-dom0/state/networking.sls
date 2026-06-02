# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{#
# Framework does not start wifi after suspend/unsuspend
# https://doc.qubes-os.org/en/latest/user/troubleshooting/resume-suspend-troubleshooting.html#drivers-do-not-reload-automatically-on-suspend-resume
# https://forum.qubes-os.org/t/qubes-users-wifi-driver-needs-to-be-blacklisted-to-be-reloaded-on-suspend-resume-since-one-of-the-last-updates/2616
#}

config-sys-net-syspend-module-iwlmvm:
  file.replace:
    - name: /rw/config/suspend-module-blacklist
    - pattern: 'iwlmvm'
    - repl: 'iwlmvm'
    - append_if_not_found: True

config-sys-net-syspend-module-iwlwifi:
  file.replace:
    - name: /rw/config/suspend-module-blacklist
    - pattern: 'iwlwifi'
    - repl: 'iwlwifi'
    - append_if_not_found: True
