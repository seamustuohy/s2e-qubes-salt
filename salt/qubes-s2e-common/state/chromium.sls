# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-chromium_update:
  pkg.uptodate:
    - refresh: True

common-chromium-install-chrome:
  pkg.latest:
    - pkgs:
      - chromium
    - allow_updates: True
    - refresh: True

config-chrome-to-use-basic-password-store:
  file.keyvalue:
    - name: '/usr/share/applications/chromium.desktop'
    - key: 'Exec'
    - value: '/usr/bin/chromium --password-store=basic %U'
    - separator: '='
    - uncomment: '#'
    - key_ignore_case: False
    - append_if_not_found: False
