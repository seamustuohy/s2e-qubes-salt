# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-enable-fstrim-timer:
  service.running:
    - name: fstrim.timer
    - enable: True
