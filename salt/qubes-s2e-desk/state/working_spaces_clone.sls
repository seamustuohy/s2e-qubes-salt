# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

#This salt file should ONLY run on the template VM.
{% if grains['nodename'] == "dom0" %}

qubes-s2e-tpl-studio_qvm-clone:
  qvm.clone:
    - name: tpl-studio-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - source: tpl-desk-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - features:
        - set:
            - menu-items:"emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
            - default-menu-items:"emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"

qubes-s2e-tpl-studio_qvm-tags:
  qvm.tags:
    - name: tpl-studio-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - add:
        - "has-dotfiles"

qubes-s2e-tpl-wkspc_qvm-clone:
  qvm.clone:
    - name: tpl-wkspc-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - source: tpl-desk-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - features:
        - set:
            - menu-items:"emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
            - default-menu-items:"emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"

qubes-s2e-tpl-wkspc_qvm-tags:
  qvm.tags:
    - name: tpl-wkspc-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - add:
        - "has-dotfiles"

## CREATE PERSONAL DESK ##
qubes-s2e-desk-personal-appvm-create:
  qvm.vm:
    - name: personal-desk
    - present:
      - template: tpl-wkspc-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - label:  orange
    - prefs:
      - netvm: "sys-firewall"
      - template: tpl-wkspc-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - autostart: False
      - include-in-backups: True
      - memory: 5000
      - maxmem: 15000
      - vcpus:  6
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
        - service.evolution-data-server
      - set:
        - menu-items: "emacs.desktop firefox-esr.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
        - default-menu-items: "emacs.desktop firefox-esr.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
    - tags:
        - add:
            - "has-dotfiles"

## UPDATE PERSONAL DESK SIZE ##

# Set volume name to change
{% set volume_name = "personal-desk" %}
# Set to 100 GB
{% set desired_volume_size =  (100 * pillar["BxGB"]) %}
# Get the current volume size
{% set current_volume_size = salt['cmd.shell']("qvm-volume info " + volume_name + ":private | grep size | cut -d ' ' -f 2- | sed 's/ *//g'") %}

{% if current_volume_size|float > desired_volume_size %}
qubes-s2e-desk-work-appvm-set-volume-size-to-10GB:
  cmd.run:
    - name: "qvm-volume extend {{ volume_name }}:private {{ desired_volume_size }}"
    - require:
        - qvm: "{{ volume_name }}"
{% endif %}

## CREATE WORK DESK ##
qubes-s2e-desk-work-appvm-create:
  qvm.vm:
    - name: work-desk
    - present:
      - template: tpl-wkspc-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - label:  purple
    - prefs:
      - netvm: "sys-firewall"
      - template: tpl-wkspc-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - include-in-backups: True
      - memory: 5000
      - maxmem: 15000
      - vcpus:  6
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
        - service.evolution-data-server
      - set:
        - menu-items: "emacs.desktop firefox-esr.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
        - default-menu-items: "emacs.desktop firefox-esr.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
    - tags:
        - add:
            - "has-dotfiles"

## UPDATE WORK DESK SIZE ##

# Set volume name to change
{% set volume_name = "work-desk" %}
# Set to 10 GB
{% set desired_volume_size =  (10 * pillar["BxGB"]) %}
# Get the current volume size
{% set current_volume_size = salt['cmd.shell']("qvm-volume info " + volume_name + ":private | grep size | cut -d ' ' -f 2- | sed 's/ *//g'") %}

{% if current_volume_size|float > desired_volume_size %}
qubes-s2e-desk-work-appvm-set-volume-size-to-10GB:
  cmd.run:
    - name: "qvm-volume extend {{ volume_name }}:private {{ desired_volume_size }}"
    - require:
        - qvm: "{{ volume_name }}"
{% endif %}


## CREATE STUDIO DESK ##
qubes-s2e-desk-studio-appvm-create:
  qvm.vm:
    - name: studio
    - present:
      - template: tpl-studio-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - label:  blue
    - prefs:
      - netvm: "sys-firewall"
      - template: tpl-studio-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - include-in-backups: True
      - memory: 400
      - maxmem: 4000
      - vcpus:  2
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
        - service.evolution-data-server
      - set:
        - menu-items: "gimp.desktop org.inkscape.Inkscape.desktop emacs.desktop firefox-esr.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
        - default-menu-items: "gimp.desktop org.inkscape.Inkscape.desktop emacs.desktop firefox-esr.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
    - tags:
        - add:
            - "has-dotfiles"

## UPDATE STUDIO SIZE ##

# Set volume name to change
{% set volume_name = "studio" %}
# Set to 2 GB
{% set desired_volume_size =  (2 * pillar["BxGB"]) %}
# Get the current volume size
{% set current_volume_size = salt['cmd.shell']("qvm-volume info " + volume_name + ":private | grep size | cut -d ' ' -f 2- | sed 's/ *//g'") %}

{% if current_volume_size|float > desired_volume_size %}
qubes-s2e-desk-studio-appvm-set-volume-size-to-2GB:
  cmd.run:
    - name: "qvm-volume extend {{ volume_name }}:private {{ desired_volume_size }}"
    - require:
        - qvm: "{{ volume_name }}"
{% endif %}

{% endif %}
