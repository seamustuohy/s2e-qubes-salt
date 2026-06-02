# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{# # Weekly fstrim - https://forum.qubes-os.org/t/disk-trimming/19054  #}
/etc/cron.weekly/trim:
  file.managed:
    - contents:
        - '#!/bin/bash'
        - '/sbin/fstrim --all'
    - mode: "0755"
    - require_in:
      - file: clean_dir
