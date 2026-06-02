# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :


{% set gui_user = salt['cmd.shell']('groupmems -l -g qubes') %}

# Update XFCE keyboard shortcuts
dom0-update_xfce_wm_keyboard_shortcuts:
  cmd.script:
    - name: "salt://qubes-s2e-dom0/files/update_xfce_shortcuts"
    - runas: {{ gui_user }}
