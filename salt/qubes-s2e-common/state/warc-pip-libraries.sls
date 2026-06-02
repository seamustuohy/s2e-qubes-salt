# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

include:
  - common.pip3

# https://github.com/webrecorder/warcio
common-warc-pip-libraries-install_warcio:
  pip.installed:
    - names:
      - "warcio"
    - bin_env: '/usr/bin/pip3'
    - ignore_installed: True
    - require:
      - sls: common.pip3

# https://github.com/webrecorder/pywb
common-warc-pip-libraries-install_pywb:
  pip.installed:
    - names:
      - "pywb"
    - bin_env: '/usr/bin/pip3'
    - ignore_installed: True
    - require:
      - sls: common.pip3


# https://github.com/webrecorder/har2warc
common-warc-pip-libraries-install_har2warc:
  pip.installed:
    - names:
      - "har2warc"
    - bin_env: '/usr/bin/pip3'
    - ignore_installed: True
    - require:
      - sls: common.pip3

# TODO: Maybe
# https://github.com/WikiTeam/wikiteam
# https://github.com/karust/gogetcrawl
# https://github.com/iipc/awesome-web-archiving#tools--software
