# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

include:
  - common.pip3

common-install_python_linters:
  pip.installed:
    - names:
      - "flake8"
      - "pylint"
      - "mypy"
      - "vale" # Linting for prose
    - bin_env: '/usr/local/bin/venv/bin/pip3'
    - ignore_installed: True
    - require:
      - sls: common.pip3
