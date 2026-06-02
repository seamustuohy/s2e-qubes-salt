# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :


{#
`check lsblk --discard output in dom0.`
# And check the values of DISC-GRAN (discard granularity) and DISC-MAX (discard max bytes) columns. Non-zero values indicate TRIM support.
#}

{# # https://forum.qubes-os.org/t/disk-trimming/19054 #}
qubes-dom0-start_fstrim_timer:
  service.running:
    - name: fstrim.timer
    - enable: True

qubes-dom0-enable_discard_in_lvm_conf:
  file.replace:
    - name: '/etc/lvm/lvm.conf'
    - pattern: 'issue_discards\s*=\s*0'
    - repl: 'issue_discards = 1'
    - ignore_if_missing: True
    - backup: False

{# # Add entry to /etc/crypttab (replace luks-<UUID> with the device name and the <UUID> with UUID alone): #}
{% set DISK_UUID = salt['cmd.shell']("sudo awk '{ print $2 }' /etc/crypttab | cut -d= -f2") %}
qubes-dom0-enable_discard_in_crypttab:
  file.replace:
    - name: '/etc/crypttab'
    - pattern: '^luks-{{ DISK_UUID }} UUID={{ DISK_UUID }}.*$'
    - repl: 'luks-{{ DISK_UUID }} UUID={{ DISK_UUID }} none discard'
    - backup: ".bak"
    - append_if_not_found: True
    - show_changes: True

{# # Make sure we are running the correct QubesOS version #}
{% if grains['osrelease'] == '4.2' %}

{#
# Qubes OS 4.2 introduced the unified GRUB config … so you should be fine with the copy (with Qubes OS 4.2, the updates always goes to /boot/grub2/grub.cfg)
# https://fedoraproject.org/wiki/Changes/UnifyGrubConfig
# https://github.com/QubesOS/qubes-issues/issues/7985

# GRUB2: /etc/default/grub, GRUB_CMDLINE_LINUX line and
# Find the line that begins with `GRUB_CMDLINE_LINUX`.
# Add: rd.luks.options=discard
# Rebuild grub config (grub2-mkconfig -o /boot/grub2/grub.cfg), # Run command `grub2-mkconfig -o /boot/efi/EFI/qubes/grub.cfg`; then
# Rebuild initrd (dracut -f)
#}

{% if not salt['file.contains_regex']('/etc/default/grub', 'GRUB_CMDLINE_LINUX_DEFAULT') %}
qubes-dom0-add-rd.luks.options-discard-to-kernel-cmdline-append:
  file.append:
    - name: /etc/default/grub
    - text: 'GRUB_CMDLINE_LINUX_DEFAULT="rd.luks.options=discard"'
  cmd.run:
    - name: 'grub2-mkconfig -o /boot/grub2/grub.cfg'
    - onchanges:
      - file: /etc/default/grub
{% elif not salt['file.contains_regex']('/etc/default/grub', 'rd.luks.options=discard') %}
qubes-dom0-add-rd.luks.options-discard-to-kernel-cmdline-replace:
  file.replace:
    - name: /etc/default/grub
    - pattern: '^GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$'
    - repl: GRUB_CMDLINE_LINUX_DEFAULT="\1 rd.luks.options=discard"
  cmd.run:
    - name: 'grub2-mkconfig -o /boot/grub2/grub.cfg'
    - onchanges:
      - file: /etc/default/grub

{% endif %}


{% elif grains['osrelease'] <= '4.1' %}
qubes-dom0-add-rd.luks.options-4.1-not-implemented-failure:
  test.fail_without_changes:
    - name: "rd.luks.options for QubesOS for 4.1 or below not tested!"
    - failhard: True
{#
   # Add rd.luks.options=discard to kernel cmdline (follow either GRUB2 or EFI, not both):
   {% set BOOT_MODE = salt['cmd.shell']('[ -d /sys/firmware/efi ] && echo "UEFI" || echo "BIOS"') %}
   # alternative check could be result of `sudo efibootmgr -v`
   {% if BOOT_MODE == 'UEFI' %}
   # DO STUFF
   {% elif BOOT_MODE == 'BIOS' %}
   {% endif %}
#}
{% else %}
qubes-dom0-add-rd.luks.options-above-4.2-not-implemented-failure:
  test.fail_without_changes:
    - name: "rd.luks.options for QubesOS above 4.2 not tested!"
    - failhard: True
{%- endif %}
