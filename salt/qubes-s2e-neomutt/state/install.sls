# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% set qube_type  = salt['pillar.get']('qubes:type', "UNKNOWN") %}
{% set qube_tags  = salt['pillar.get']('qubes:tags', []) %}

###### TEMPLATE #######
{% if qube_type == "template" %}

qubes-s2e-neonotmuch-template-install-pkg-update:
  pkg.uptodate:
    - refresh: True

{# # Universal mailvm + cold store template software install #}
qubes-s2e-universal_neonotmuch-template-installed:
  pkg.installed:
    - pkgs:
      - man-db
      - neomutt
      - notmuch
      - afew
      - less
      - urlview
      - w3m
      - urlscan
      - terminator
      - libmime-tools-perl
      - libhtml-parser-perl

{% if 'mail-cold-storage-template' in qube_tags %}
{# # Cold storage template software install #}
qubes-s2e-neonotmuch-cold-store-template-installed:
  pkg.installed:
    - pkgs:
      - rsync # merging stored
      - jq # working with notmuch --format=json
      - fzf # notmuch_browse
      - maildir-utils # notmuch_browse

{% else %}

{# # Mail App VM template software install #}
qubes-s2e-neonotmuch-app-vm-template-installed:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - qubes-app-shutdown-idle
      - qubes-pdf-converter
      - qubes-img-converter
      - lieer
      - emacs # Composition
      - ispell # Composition
      - dictionaries-common # Composition
      - iamerican # Composition
      - pandoc # Convert Composed

{% endif %}
qubes-s2e-neonotmuch-template-locale-iso88:
  locale.present:
    - name: "en_US ISO-8859-1"

qubes-s2e-neonotmuch-template-locale-iso8815:
  locale.present:
    - name: "en_US.ISO-8859-15 ISO-8859-15"

qubes-s2e-neonotmuch-template-locale-utf8:
  locale.present:
    - name: "en_US.UTF-8 UTF-8"


{% endif %}
