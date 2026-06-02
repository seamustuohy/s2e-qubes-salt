# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-tor-installs:
  pkg.installed:
    - pkgs:
      - tor
      - torsocks
      - torbrowser-launcher
