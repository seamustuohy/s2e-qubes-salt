# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

### READER ###
{% set qube_type  = salt['pillar.get']('qubes:type', "UNKNOWN") %}
{% set qube_tags  = salt['pillar.get']('qubes:tags', []) %}

###### TEMPLATE #######
#This salt file should ONLY run on the template VM.
{% if qube_type == "template" %}

qubes-s2e-rpmbuild_update:
  pkg.uptodate:
    - refresh: True

qubes-s2e-rpmbuild-install:
  pkg.installed:
    - pkgs:
      - rpmdevtools
      - rpmlint
      - jq

{% endif %}
