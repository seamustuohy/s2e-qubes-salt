# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

install-python-development-tools:
  pkg.installed:
    - pkgs:
      - python3
      - python3-pip
      - python3-dev
      - python3-setuptools
      - python3-wheel
      - python3-venv
