# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-design_update:
  pkg.uptodate:
    - refresh: True

common-design-install-art-tools:
  pkg.installed:
    - pkgs:
      - inkscape
      - gimp
      - mpv
      - cheese

common-design-install-inkstitch:
  pkg.installed:
    - sources:
      - inkstitch: 'salt://common/files/inkstitch.deb'
