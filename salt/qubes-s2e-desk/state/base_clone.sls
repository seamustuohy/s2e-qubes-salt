# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

#This salt file should ONLY run on the template VM.
{% if grains['nodename'] == "dom0" %}

qubes-s2e-desk_precursor:
  qvm.template_installed:
    - name: debian-{{ pillar["os"]["template"]["base_version"]["debian"] }}

## TEMPLATES ##

qubes-s2e-tpl-base_qvm-clone:
  qvm.clone:
    - name: tpl-base-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - source: debian-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - features:
        - set:
            - menu-items:"emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"
            - default-menu-items:"emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop"


{% endif %}
