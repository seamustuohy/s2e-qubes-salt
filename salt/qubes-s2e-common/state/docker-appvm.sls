# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

# Add running dockerd every time your app VM boots to the appvm's rc.local
common-docker-appvm-add-rc-dot-local:
  file.replace:
    - name: /rw/config/rc.local
    - append_if_not_found: True
    - pattern: "dockerd &"
    - repl: "dockerd &"
