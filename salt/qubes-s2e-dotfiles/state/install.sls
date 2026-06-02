# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

include:
  - common.update_pkgs

qubes-s2e-dotfiles_update:
  pkg.uptodate:
    - refresh: True

qubes-s2e-dotfiles-install:
  pkg.installed:
    - require:
      - sls: common.update_pkgs
    - pkgs:
      - git

# Dotfile repo is stored in the template
{% set dotfiles_path = "/etc/dotfiles" %}

# Templates use a proxy to access the internet
# So, we set this env variable to push git through that proxy
dotfiles_update_dotfiles_via_git_proxy:
  environ.setenv:
    - name: set_proxy_env_vars
    - value:
        http_proxy: "http://127.0.0.1:8082"
        https_proxy: "http://127.0.0.1:8082"
        HTTP_PROXY: "http://127.0.0.1:8082"
        HTTPS_PROXY: "http://127.0.0.1:8082"

# See proxy above.
dotfiles_update_dotfiles_with_git:
  git.latest:
    - name: https://github.com/seamustuohy/dotfiles.git
    - target: "{{ dotfiles_path }}"
    - branch: main


# Linux Packages used in dotfiles which may not be on systems

# - imagemagick
# - gzip
# - sed
# - gpg
# - xmllint
# - lvm2
# - cryptsetup
# - dmenu
# - torify

# Python packages
# - pip install rake-nltk
# - python -c "import nltk; nltk.download('stopwords')"
# - sumy
# - from bs4 import BeautifulSou
# - python-mechanize module ( import  mechanize )
# - import idna
# - requests ( import requests )
