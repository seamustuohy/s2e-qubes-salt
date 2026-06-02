# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

install-timetaskwarrior-pkg-deps:
  pkg.installed:
    - pkgs:
      - timewarrior
      - taskwarrior
