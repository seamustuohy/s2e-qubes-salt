# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

#This salt file should ONLY run on dom0.
{% if grains['nodename'] == "dom0" %}

qubes-s2e-neomutt-add-create-neomutt-vm-script:
  file.managed:
    - source: "salt://qubes-s2e-neomutt/files/qvm-make-vm-neomutt.sh"
    - name: /usr/bin/qvm-make-vm-neomutt
    - mode: 755
    - user: root
    - group: root

{% endif %}
