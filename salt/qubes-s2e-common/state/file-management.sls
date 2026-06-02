# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

include:
  - common.update_pkgs

common-file-management-install-filesystem-exploration-tools:
  pkg.installed:
    - require:
      - sls: common.update_pkgs
    - pkgs:
      - lsof
      - tree
      - fzf

common-file-management-install-file-compression-decompression:
  pkg.installed:
    - require:
      - sls: common.update_pkgs
    - pkgs:
      - unzip
      - zip
      - p7zip
{% if grains['os_family']|lower == 'debian' %}
      - p7zip-full
      - unrar-free
{% endif %}

common-file-management-install-file-management-tools:
  pkg.installed:
    - require:
      - sls: common.update_pkgs
    - pkgs:
      - progress # Shows progress on file manipulations (cp, mv, dd, ...)
      - rsync
