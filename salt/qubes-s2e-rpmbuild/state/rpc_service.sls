# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

### READER ###
{% set qube_type  = salt['pillar.get']('qubes:type', "UNKNOWN") %}
{% set qube_tags  = salt['pillar.get']('qubes:tags', []) %}

###### TEMPLATE #######
#This salt file should ONLY run on the template VM.
{% if qube_type == "template" %}

qubes-s2e-add-RpmBuild-Service:
  file.managed:
    - name: /etc/qubes-rpc/qubes.RpmBuild
    - mode: 755
    - source: salt://qubes-s2e-rpmbuild/files/qubes.RpmBuild
    - replace: True
    - clean: True

{% endif %}
