# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :


common-install-yt-dlp-pkg-deps:
  pkg.installed:
    - pkgs:
      - ffmpeg

common-install-yt-dlp_mkdir:
  file.directory:
    - name: /home/user/bin

common-install-yt-dlp-_python_linters:
  pip.installed:
    - names:
      - "yt-dlp-ejs" #  Required for full YouTube support.
    - bin_env: '/usr/local/bin/venv/bin/pip3'
    - ignore_installed: True
    - require:
      - sls: common.pip3

common-install-yt-dlp-source-pip-venv-when-loading-term:
  file.replace:
    - name: '/home/user/.bashrc'
    - pattern: 'source /usr/local/bin/venv/bin/activate'
    - repl: 'source /usr/local/bin/venv/bin/activate'
    - append_if_not_found: True

common-install-yt-dlp-copy_file_yt-dlp-to-bin:
  file.managed:
    - name: '/home/user/bin/yt-dlp'
    - source: 'salt://common/files/yt-dlp'
    - makedirs: True
    - replace: True
    - user: root
    - group: root
    - mode: "0755"

common-install-yt-dlp-copy_file_deno-to-bin:
  file.managed:
    - name: '/home/user/.deno/bin/deno'
    - source: 'salt://common/files/deno'
    - makedirs: True
    - replace: True
    - user: user
    - group: user
    - mode: "0755"

common-install-yt-dlp-run-deno-reload:
  cmd.run:
    - name: "/home/user/.deno/bin/deno run -A --reload jsr:@deno/installer-shell-setup/bundled /home/user/.deno -y"
    - runas: user
