# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-pip-deps-install:
  pkg.installed:
    - pkgs:
      - build-essential
      - python3-dev
      - python3-venv
      - virtualenv

s2es-app-common-ensure_python_virtualenv_directory:
  file.directory:
    - name: /usr/local/bin/venv
    - user: user
    - group: user
    - mode: "0755"
    - makedirs: true

s2es-app-common-install-virtualenv:
  virtualenv.managed:
    - name: '/usr/local/bin/venv'
    - pip_upgrade: True
    - user: user
    - group: user
