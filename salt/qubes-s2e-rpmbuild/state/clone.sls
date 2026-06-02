# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

#This salt file should ONLY run on the template VM.
{% if grains['nodename'] == "dom0" %}
qubes-s2e-rpmbuild_precursor:
  qvm.template_installed:
    - name: fedora-{{ pillar["os"]["template"]["base_version"]["fedora"] }}-minimal

qubes-s2e-rpmbuild_qvm-clone:
  qvm.clone:
    - name: tpl-rpmbuild-{{ pillar["os"]["template"]["base_version"]["fedora"] }}
    - source: fedora-{{ pillar["os"]["template"]["base_version"]["fedora"] }}-minimal
    - prefs:
        - management_dispvm: fedora-{{ pillar["os"]["template"]["base_version"]["fedora"] }}-xfce
    - features:
        - set:
            - menu-items:"qubes-run-terminal.desktop qubes-start.desktop"
            - default-menu-items:"qubes-run-terminal.desktop qubes-start.desktop"

# Note: if template_for_dispvms is put here it won't set properly for some reason.
# The salt output will say that it [SKIP]'s the template in the ['prefs'] comment.
# So, maybe it tosses everything after that skipped variable or something?
qubes-s2e-rpmbuild_create_rpmbuild_dispvm:
  qvm.vm:
    - name: rpmbuild-dispvm
    - require:
      - qvm: tpl-rpmbuild-{{ pillar["os"]["template"]["base_version"]["fedora"] }}
    - present:
      - template: tpl-rpmbuild-{{ pillar["os"]["template"]["base_version"]["fedora"] }}
      - label: red
    - prefs:
      - template_for_dispvms: True
      - management_dispvm: fedora-{{ pillar["os"]["template"]["base_version"]["fedora"] }}-xfce
      - netvm: 'sys-firewall'
      - include-in-backups: False
      - memory: 200
      - maxmem: 400
      - vcpus:  2
      - template: tpl-rpmbuild-{{ pillar["os"]["template"]["base_version"]["fedora"] }}
    - features:
        - set: # Note: Application shortcuts for the appmenu will not set if you set them here.
            - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
            - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
        - enable:
            - appmenus-dispvm
        - disable:
            - service.cups
            - service.cups-browsed

qubes-s2e-rpmbuild_udpate_rpmbuild_dispvm_menus:
  qvm.features:
    - name: rpmbuild-dispvm
    - set: # Note: Setting appmenu shortcuts again per note in qvm.vm above.
      - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
      - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
    - require:
        - qvm: qubes-s2e-rpmbuild_create_rpmbuild_dispvm


## DEVELOPMENT VMs

qubes-s2e-rpmbuild_development_template-clone:
  qvm.clone:
    - name: tpl-rpmdev-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - source: tpl-code-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - features:
        - set:
            - menu-items: "emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop firefox-esr.desktop"
            - default-menu-items: "emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop firefox-esr.desktop"


qubes-s2e-rpmbuild_development_appvm:
  qvm.vm:
    - name: qubes-salt-dev
    - present:
      - template: tpl-rpmdev-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - label: green
    - prefs:
      - netvm: 'sys-firewall'
      - template: tpl-rpmdev-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - include-in-backups: True
    - tags:
      - add:
        - "rpmdev"

{% endif %}
