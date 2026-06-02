# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-net-utils-get-content:
  pkg.installed:
    - pkgs:
      - wget
      - curl

common-net-utils-get-info:
  pkg.installed:
    - pkgs:
      - whois
      - bind9-dnsutils # dig, nslookup
