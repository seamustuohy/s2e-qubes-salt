# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

common-docker-engine-preqrequisite-installs:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl
      - gnupg

# Ususally would use a signed-by key. But, we're not using that
# deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian   bullseye stable
common-docker-debian-configure-docker-repo:
  pkgrepo.managed:
    - name: "deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable"
    - file: "/etc/apt/sources.list.d/docker.list"
    - key_url: "salt://common/files/docker-key.gpg"
    - clean_file: True # squash file to ensure there are no duplicates

common-docker-update-docker-repo:
  pkg.uptodate:
    - refresh: True

common-docker-install-docker-engine:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-buildx-plugin
      - docker-compose-plugin

common-docker-create-docker-daemon-config:
  file.managed:
    - name: '/etc/docker/daemon.json'
    - source: "salt://common/files/docker-daemon.json"
    - makedirs: True
    - replace: True
    - clean: True
