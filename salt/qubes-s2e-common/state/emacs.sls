# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

install-emacs-and-pkg-deps:
  pkg.installed:
    - pkgs:
      - emacs
      - sqlite3
      - silversearcher-ag
      - ack
      - ispell
      - dictionaries-common
      - iamerican
      - uuid-runtime # uuidgen
    - refresh: True

set-emacs30-as-default-alternative:
    cmd.run:
      - name: |
          sudo update-alternatives --install /usr/bin/editor editor "$(which emacs)" 60
      - user: user
