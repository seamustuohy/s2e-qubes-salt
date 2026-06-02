# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

#This salt file should ONLY run on dom0.
{% if grains['nodename'] == "dom0" %}

qubes-s2e-neomutt-update-neomutt-policy:
  file.managed:
    - source: "salt://qubes-s2e-neomutt/files/30-neomutt.policy"
    - name: /etc/qubes/policy.d/30-neomutt.policy
    - mode: 664
    - user: root
    - group: qubes

{% endif %}
