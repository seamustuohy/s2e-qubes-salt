# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :


# Only run on AppVM's
{% set qube_type  = salt['pillar.get']('qubes:type', "UNKNOWN") %}
{% if qube_type == "app" %}

# Fix window size in LibreOffice
# https://groups.google.com/g/qubes-users/c/GA21ZTGWWBA/m/2ATd3VhmAgAJ
fix_libreoffice_window_size:
  file.replace:
    - name: /home/user/.config/libreoffice/4/user/registrymodifications.xcu
    - pattern: "^(<item.+ooSetupFactoryWindowAttributes.+<value>[0-9]+,[0-9]+)(,[0-9]+,[0-9]+)(;[0-9]+;[0-9]+,[0-9]+,[0-9]+,[0-9]+;</value></prop></item>$)"
    - repl: '\1,1000,1000\3'
    - ignore_if_missing: True

{% endif %}
