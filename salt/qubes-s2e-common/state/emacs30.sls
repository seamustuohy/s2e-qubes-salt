# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

install-emacs30-pkg-deps:
  pkg.installed:
    - pkgs:
      - sqlite3
      - silversearcher-ag
      - ack
      - ispell
      - dictionaries-common
      - iamerican
      - uuid-runtime # uuidgen

install-emacs30-backports-repo:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware
    - dist: bookworm-backports
    - file: /etc/apt/sources.list.d/backports.list
    - refresh_db: true

install-emacs30-cd2_repo-update:
  pkg.uptodate:
    - refresh: True

install-emacs30.packages:
  pkg.latest:
    - fromrepo: bookworm-backports
    - version: '1:30.*'
    - pkgs:
      - emacs

set-emacs30-as-default-alternative:
    cmd.run:
      - name: |
          sudo update-alternatives --install /usr/bin/editor editor "$(which emacs)" 60
      - runas: "user"
