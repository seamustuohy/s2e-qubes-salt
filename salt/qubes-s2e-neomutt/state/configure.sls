# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{# # Conditional execution based on tag search template #}
{% set qube_tags  = salt['pillar.get']('qubes:tags', []) %}

{% set qube_type  = salt['pillar.get']('qubes:type', "UNKNOWN") %}
###### APP #######
{% if qube_type == "app" %}

qubes-s2e-neomutt-create-mail-dir:
  file.directory:
    - name: /home/user/mail/
    - mode: '0777'
    - user: user
    - group: user
    - makedirs: True

qubes-s2e-neomutt-app-mailcap:
  file.managed:
    - name: /home/user/.mailcap
    - source: salt://qubes-s2e-neomutt/files/mailcap
    - mode: "0644"
    - user: user
    - group: user
    - makedirs: True

qubes-s2e-neomutt-app-notmuch-afew-config-folder:
  file.directory:
    - name: /home/user/.config/afew
    - mode: '0777'
    - user: user
    - group: user
    - makedirs: True

qubes-s2e-neomutt-app-notmuch-afew-blank-blockfile:
  file.managed:
    - name: /home/user/.config/afew/blocked.lsv
    - mode: "0644"
    - user: user
    - group: user
    - makedirs: True

qubes-s2e-neomutt-app-notmuch-afew-hook:
  file.managed:
    - name: /home/user/.notmuch/hooks/post-new
    - source: salt://qubes-s2e-neomutt/files/post-new
    - mode: "0755"
    - user: user
    - group: user
    - makedirs: True

# ixon and ixoff are used to insist that Ctrl-s and Ctrl-q be interpreted as control flow (scroll lock) signals.
# This is needed for Ctrl-s shortcuts in neomutt
qubes-s2e-neomutt-ensure_stty-line_in_bashrc:
  file.append:
    - name: /home/user/.bashrc
    - text: "stty -ixon"


## Allow use of full color range START
qubes-s2e-neomutt-ensure_neomutt_term_alias_in_bashrc:
  file.append:
    - name: /home/user/.bashrc
    - text: "alias neomutt='TERM=xterm-direct neomutt'"

qubes-s2e-neomutt-create-neomutt-local-desktop-app-dir:
  file.directory:
    - name: /home/user/.local/share/applications/
    - mode: '0777'
    - user: user
    - group: user
    - makedirs: True

qubes-s2e-neomutt-copy_neomutt_desktop_file_locally:
  file.managed:
    - name: /home/user/.local/share/applications/neomutt.desktop
    - source: /usr/share/applications/neomutt.desktop
    - user: user
    - group: user
    - mode: 644

qubes-s2e-neomutt-update_neomutt_local_desktop_file:
  file.replace:
    - name: /home/user/.local/share/applications/neomutt.desktop
    - pattern: '^Exec=.*'
    - repl: 'Exec=env TERM=xterm-direct neomutt %u'
## Allow use of full color range END

# URL should open urls in a dvm
ensure_url_view_uses_open-in-dvm:
  file.append:
    - name: /home/user/.urlview
    - text: "COMMAND qvm-open-in-vm dmv-neomutt-browser %s &"

qubes-s2e-neomutt-install-extract-url:
  file.managed:
    - name: /home/user/.mutt/scripts/extract_url.pl
    - source: salt://qubes-s2e-neomutt/files/extract_url.pl
    - mode: "0755"
    - user: user
    - group: user
    - makedirs: True

{% if 'neomutt-vm' in qube_tags %}
qubes-s2e-neomutt-emacs-config:
  file.managed:
    - name: /home/user/.emacs
    - source: salt://qubes-s2e-neomutt/files/.emacs
    - mode: "0644"
    - user: user
    - group: user
    - makedirs: True

qubes-s2e-neomutt-emacs-email-snippet-directory:
  file.directory:
    - name: /home/user/.emacs.d/snippets/message-mode
    - mode: '0777'
    - user: user
    - group: user
    - makedirs: True

  file.managed:
    - name: /home/user/.emacs
    - source: salt://qubes-s2e-neomutt/files/.emacs
    - mode: "0644"
    - user: user
    - group: user
    - makedirs: True


qubes-s2e-neomutt-store_transferred_cold_storage:
  file.managed:
    - name: /home/user/.mutt/scripts/move_message_to_cold_storage.py
    - source: salt://qubes-s2e-neomutt/files/move_message_to_cold_storage.py
    - mode: "0755"
    - user: user
    - group: user
    - makedirs: True
{% endif %}

{% if 'mail-cold-storage' in qube_tags %}
qubes-s2e-neomutt-cold-storage-notmuch-config:
  file.managed:
    - name: /home/user/.notmuch-config
    - source: salt://qubes-s2e-neomutt/files/CS_notmuch_config
    - mode: "0644"
    - user: user
    - group: user
    - makedirs: True

{% endif %}
