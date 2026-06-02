# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

include:
  - common.update_pkgs

qubes-s2e-code-install:
  pkg.installed:
    - require:
      - sls: common.update_pkgs
    - pkgs:
      - git
      - build-essential
      - xxd
