# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

#This salt file should ONLY run on the template VM.
{% if grains['nodename'] == "dom0" %}
tpl-tpl-TEST_precursor:
  qvm.template_installed:
    - name: debian-{{ pillar["os"]["template"]["base_version"]["debian"] }}-minimal

tpl-tpl-TEST_qvm-clone:
  qvm.clone:
    - name: tpl-tpl-TEST-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - source: debian-{{ pillar["os"]["template"]["base_version"]["debian"] }}-minimal

{# # Features to disable/enable: https://dev.qubes-os.org/projects/core-admin-client/en/latest/manpages/qvm-service.html#supported-services
#}

tpl-TEST-appvm-create:
  qvm.vm:
    - name: tpl-TEST-appvm
    - present:
      - template: tpl-tpl-TEST-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - label:  yellow  # red|yellow|green|blue|purple|orange|gray|black
    - prefs:
        - template: tpl-tpl-TEST-{{ pillar["os"]["template"]["base_version"]["debian"] }}
        - autostart: False
        - include_in_backups: False
        - template_for_dispvms: False
        - netvm: "sys-firewall"
        #- audiovm: "*default*"
        #- memory: 300
        #- maxmem: 800
        #- vcpus: 2
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
        # - service.evolution-data-server
      - set:
        - menu-items: "qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
        - default-menu-items: "qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"


# Set volume name to change
{% set volume_name = "tpl-TEST-appvm" %}
# Set to 2 GB
{% set desired_volume_size =  (2 * pillar["BxGB"]) %}
# Get the current volume size
{% set current_volume_size = salt['cmd.shell']("qvm-volume info {{volume_name}}:private | grep size | cut -d ' ' -f 2- | sed 's/ *//g'") %}

{% if current_volume_size|float > desired_volume_size %}
tpl-TEST-studio-appvm-set-volume-size-to-2GB:
  cmd.run:
    - name: "qvm-volume extend {{volume_name}}:private {{desired_volume_size}}"
    - require:
        - qvm: "{{volume_name}}"
{% endif %}


{#
# menu-favorites: "@disp:..." items can be prefixed with @disp:, which indicated they should be executed in a new disposable VM based on the one, on which the feature is set. # https://github.com/QubesOS/qubes-desktop-linux-menu/blob/4d858cdbbc4ee0ee9bb0e04beb9fd9cf487c3047/qubes_menu/constants.py#L42
#}
{#
tpl-TEST-dispvm-template-create:
  qvm.vm:
    ...
    ...
    - prefs:
      - template_for_dispvms: True
    ....
    - features:
      - enable:
        - appmenus-dispvm
      - set:
        - menu-items: qubes-run-terminal.desktop
        - menu-favorites: "@disp:qubes-run-terminal"
#}


{% endif %}
