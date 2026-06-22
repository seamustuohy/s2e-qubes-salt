# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{# # Setup autostart for the set_displays.sh script needed to add zoomed displays to framework #}
dom0_add_framework_custom_display_modes:
  file.managed:
    - name: '/home/s2e/.config/autostart/framework-display-options.desktop'
    - source: 'salt://qubes-s2e-dom0/files/framework-display-options.desktop'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: 655

{% if salt['cmd.shell']("cat /sys/power/mem_sleep") != 's2idle [deep]' %}
configure-suspend-in-grub:
  file.replace:
    - name: /etc/default/grub
    - pattern: {{ 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX mem_sleep_default=deep"' | regex_escape }}
    - repl: 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX mem_sleep_default=deep"'
    - append_if_not_found: True

update-grub-config:
  cmd.run:
    - name: 'grub2-mkconfig -o /boot/efi/EFI/qubes/grub.cfg'
    - require:
      - configure-suspend-in-grub

{% endif %}

autostart-set-keymap-noctrl:
  file.managed:
    - name: '/home/s2e/.config/autostart/nocaps-keyboard'
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Icon=input-keyboard
        Name=No Caps 4 Keyboard
        Categories=System
        Exec=setxkbmap -option ctrl:nocaps && setxkbmap -option caps:ctrl_modifier
        TryExec=setxkbmap
        Terminal=false
        Type=Application
    - user: root
    - group: root
    - mode: 644

# autostart-set-keymap:
#   file.managed:
#     - name: /etc/xdg/autostart/framwork_display_set
#     - makedirs: True
#     - contents: |
#         [Desktop Entry]
#         Icon=preferences-desktop-screensaver
#         Name=Set Framework display settings
#         Categories=System
#         Exec=framwork_display_set
#         TryExec=framwork_display_set
#         Terminal=false
#         Type=Application
#     - user: root
#     - group: root
#     - mode: 644


# Change the copy between qubes hotkey to the windows key
config-qubes-use-windows-key-for-domain-copy-paste:
  qvm.features:
    - name: dom0
    - set:
      - gui-default-secure-copy-sequence: 'Mod4-c'
      - gui-default-secure-paste-sequence: 'Mod4-v'

ensure_touchpad_tapping_on_frameworks_unusable_touchpad:
  file.managed:
    - name: /etc/X11/xorg.conf.d/99-touchpad-tapping.conf
    - makedirs: True
    - contents: |
        Section "InputClass"
            Identifier "touchpad tapping override"
            MatchIsTouchpad "on"
            Option "Tapping" "on"
        EndSection
