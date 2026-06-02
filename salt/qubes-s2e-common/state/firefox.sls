# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

# pkgrepo.managed won't refresh the publickey unless the file is removed. So, we need to delete the file first
common-remove-firefox-apt-file-to-refresh-key:
  file.absent:
    - name: "/etc/apt/sources.list.d/mozilla.list"

common-add-firefox-key-to-keyring:
  file.managed:
    - name: /etc/apt/keyrings/packages.mozilla.org.asc
    - mode: "0644"
    - source: salt://common/files/packages.mozilla.org.asc

common-firefox-configure-remote-apt-repo:
  pkgrepo.managed:
    - name: "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main"
    - file: "/etc/apt/sources.list.d/mozilla.list"
    - require:
        - file: common-add-firefox-key-to-keyring
    - clean_file: True # squash file to ensure there are no duplicates
    - aptkey: False

common-add-firefox-pinned-to-mozilla-as-priority-install:
  file.managed:
    - name: /etc/apt/preferences.d/mozilla
    - mode: "0644"
    - source: salt://common/files/preferences.d.mozilla

common-firefox_update:
  pkg.uptodate:
    - refresh: True

common-install-firefox:
  pkg.latest:
    - pkgs:
      - firefox
    - allow_updates: True
    - refresh: True
