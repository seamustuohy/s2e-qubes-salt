# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

#This salt file should ONLY run on dom0
{% if grains['nodename'] == "dom0" %}

qubes-s2e-neomutt_precursor:
  qvm.template_installed:
    - name: debian-{{ pillar["os"]["template"]["base_version"]["debian"] }}-minimal

qubes-s2e-neomutt-template_qvm-clone:
  qvm.clone:
    - name: tpl-qubes-s2e-neomutt
    - source: debian-{{ pillar["os"]["template"]["base_version"]["debian"] }}-minimal
    - prefs:
        - audiovm: ""

qubes-s2e-neomutt-template_qvm-clone-numbered:
  qvm.clone:
    - name: tpl-qubes-s2e-neomutt-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - source: debian-{{ pillar["os"]["template"]["base_version"]["debian"] }}-minimal
    - prefs:
        - audiovm: ""


# === COLD STORAGE - Template ===
qubes-s2e-neomutt-cold_storage-template-numbered:
  qvm.clone:
    - name: tpl-qubes-s2e-neomutt-CS-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - source: debian-{{ pillar["os"]["template"]["base_version"]["debian"] }}-minimal
    - prefs:
        - audiovm: ""
    - tags:
        - add:
            - mail-cold-storage-template

# === COLD STORAGE - APP VM ===
qubes-s2e-neomutt_create_cold_storage:
  qvm.vm:
    - name: mail-cold-storage
    - require:
      - qvm: tpl-qubes-s2e-neomutt-CS-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - present:
      - template: tpl-qubes-s2e-neomutt-CS-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - label: green
    - prefs:
      - template_for_dispvms: False
      - audiovm: ""
      - netvm: 'sys-firewall'
      - include-in-backups: False
      - memory: 200
      - maxmem: 350
      - vcpus:  1
      - template: tpl-qubes-s2e-neomutt-CS-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - features:
        - disable:
            - service.cups
            - service.cups-browsed
            - service.tinyproxy
        - enable:
            - service.crond
        - set:
            - menu-items: "mutt.desktop qubes-run-terminal.desktop qubes-start.desktop"
            - default-menu-items: "mutt.desktop qubes-run-terminal.desktop qubes-start.desktop"
    - tags:
        - add:
            - mail-cold-storage


## ==== Browser Disp-VM ====

# Define the Named Disposable VM
named-email-browser-disposable-qube:
  qvm.present:
    - name: dvm-neomutt-browser # persistent name for this VM
    - class: DispVM             # Specifies this is a Disposable VM
    - template: default-dvm     # The Disposable Template it is based on
    - label: red                # The color label for the qube
    - prefs:
        - netvm: sys-firewall

{% endif %}
