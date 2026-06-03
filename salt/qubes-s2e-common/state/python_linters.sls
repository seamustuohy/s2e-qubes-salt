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

{# # Ensures that the pip directory is sourced with linters when the Emacs (GUI) is run #}
install_linted_emacs_desktop_entry:
  file.managed:
    - name: /home/user/.local/share/applications/emacs.desktop
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Version=1.0
        Name=Emacs (GUI/Py-Linted)
        GenericName=Text Editor
        Comment=A Lint-enabled version of GNU Emacs, which is an extensible, customizable text editor - and more
        MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
        TryExec=/usr/bin/emacs
        Exec=bash -c "source /usr/local/bin/venv/bin/activate && exec /usr/bin/emacs %F"
        Icon=emacs
        Type=Application
        Terminal=false
        Categories=Utility;Development;TextEditor;
        StartupWMClass=Emacs
        Keywords=Text;Editor;
    - user: user
    - group: user
    - mode: 644
