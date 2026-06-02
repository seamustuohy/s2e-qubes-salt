# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-sys-utils-install-system-management-tools:
  pkg.installed:
    - pkgs:
      - sysstat

common-sys-utils-install-content-manipulation-tools:
  pkg.installed:
    - pkgs:
        - xclip
