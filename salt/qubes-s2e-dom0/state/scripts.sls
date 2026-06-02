# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

copy_file_quf_screenshot_region_for_appmenu:
  file.managed:
    - name: '/usr/local/bin/quf_screenshot_region.sh'
    - source: 'salt://qubes-s2e-dom0/files/qubes/quf_screenshot_region.sh'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 755

copy_file_quf_screenshot_active_window_for_appmenu:
  file.managed:
    - name: '/usr/local/bin/quf_screenshot_active_window.sh'
    - source: 'salt://qubes-s2e-dom0/files/qubes/quf_screenshot_active_window.sh'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 755

dom0_add_bashrc_scripts_brightness:
  file.managed:
    - name: '/home/s2e/.bashrc.d/brightness.sh'
    - source: 'salt://qubes-s2e-dom0/files/bashrc/brightness.sh'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 755

{# # Run by /home/s2e/.config/autostart/framework-display-options.desktop #}
dom0_add_bashrc_scripts_framework_display:
  file.managed:
    - name: '/home/s2e/.bashrc.d/set_displays.sh'
    - source: 'salt://qubes-s2e-dom0/files/bashrc/set_displays.sh'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 755
