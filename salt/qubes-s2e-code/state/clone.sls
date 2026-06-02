# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% if grains['nodename'] == "dom0" %}

template-code_qvm-clone:
  qvm.clone:
    - name: tpl-code-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - source: tpl-base-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - features:
      - set:
        - menu-items: "emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop firefox-esr.desktop"
        - default-menu-items: "emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop firefox-esr.desktop"
    - tags:
        - add:
            - "has-dotfiles"

qubes-s2e-tpl-code_qvm-tags:
  qvm.tags:
    - name: tpl-code-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - add:
        - "has-dotfiles"

template-code_menu:
  qvm.features:
    - name: tpl-code-{{ pillar["os"]["template"]["base_version"]["debian"] }}
    - set:
      - menu-items: "emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop firefox-esr.desktop"
      - default-menu-items: "emacs.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop firefox-esr.desktop"

template-code_python-qvm_vm:
  qvm.vm:
    - name: disp-py-code
    - present:
      - template: tpl-code-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - label: green
    - prefs:
      - netvm: 'sys-firewall'
      - template: tpl-code-{{ pillar["os"]["template"]["base_version"]["debian"] }}
      - include-in-backups: False
      - template-for-dispvms: true
    - features:
      - enable:
        - appmenus-dispvm
      - set:
        - menu-items: qubes-run-terminal.desktop
        - menu-favorites: "@disp:qubes-run-terminal"

qubes-s2e-disp-py-code_qvm-tags:
  qvm.tags:
    - name: disp-py-code
    - add:
        - "has-dotfiles"

{% endif %}
