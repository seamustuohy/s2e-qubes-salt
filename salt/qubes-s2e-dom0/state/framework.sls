# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{# # Setup autostart for the set_displays.sh script needed to add zoomed displays to framework #}

/etc/X11/xorg.conf.d/10-monitor.conf:
  file.managed:
    - makedirs: True
    - contents: |
        Section "Monitor"
            Identifier "eDP-1"
            Modeline "1368x912"  103.00  1368 1448 1592 1816  912 915 925 947 -hsync +vsync
            Option "PreferredMode" "1368x912"
        EndSection

        Section "Screen"
            Identifier "Screen0"
            Device     "Card0"
            Monitor    "eDP-1"
            SubSection "Display"
                Modes "1368x912"
            EndSubSection
        EndSection

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

config-dom0-set_caps_to_ctrl:
  cmd.run:
    - name: localectl set-x11-keymap us "" "" ctrl:nocaps
    - unless: localectl status | grep -E "X11 Options:.*ctrl:nocaps"

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
    - user: root
    - group: root
    - mode: 644
