# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-install_yt_dlp_mkdir:
  file.directory:
    - name: /home/user/bin

copy_file_quf_screenshot_region_for_appmenu:
  file.managed:
    - name: '/home/user/bin/yt-dlp'
    - source: 'salt://common/files/yt-dlp'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: "0755"
