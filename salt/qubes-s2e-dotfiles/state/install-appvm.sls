# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% set dotfiles_path = "/etc/dotfiles" %}
{% set user = "user" %}
{% set home = "/home/user" %}

/usr/local/bin directory:
  file.directory:
    - name: /usr/local/bin
    - makedirs: True

{{ home }}/.emacs.d/snippets directory:
  file.directory:
    - name: {{ home }}/.emacs.d/snippets
    - makedirs: True
    - user: {{ user }}

{{ home }}/.config/fontconfig directory:
  file.directory:
    - name: {{ home }}/.config/fontconfig
    - makedirs: True
    - user: {{ user }}

{{ home }}/.config/fonts/truetype directory:
  file.directory:
    - name: {{ home }}/.config/fonts/truetype
    - makedirs: True
    - user: {{ user }}

{{ home }}/.local/share/fonts/truetype directory:
  file.directory:
    - name: {{ home }}/.local/share/fonts/truetype
    - makedirs: True
    - user: {{ user }}

# Ensure user can read all
# setfacl format [u/g/o/m]:[name]:[rwx]
# https://wiki.archlinux.org/title/Access_Control_Lists
qubes_s2e_dotfiles_set_user_permissions_to_read_all:
  cmd.run:
    - name: |
        find "{{ dotfiles_path }}" -type f | while read -r f; do
          sudo setfacl -m u:{{ user }}:r "$f"
        done
    - runas: {{ user }}

# Includes bin's in nested dirs. Excludes hidded (.) files/dirs
# setfacl format [u/g/o/m]:[name]:[rwx]
# https://wiki.archlinux.org/title/Access_Control_Lists
qubes_s2e_dotfiles_set_user_permissions_to_execute_bins:
  cmd.run:
    - name: |
        find "{{ dotfiles_path }}/bin/" -type f | while read -r f; do
          sudo setfacl -m u:{{ user }}:rx "$f"
        done
    - runas: {{ user }}

# Includes bin's in nested dirs. Excludes hidded (.) files/dirs
qubes_s2e_dotfiles_link_/usr/local/bin:
  cmd.run:
    - name: |
        find "{{ dotfiles_path }}/bin/" -type f | while read -r f; do
          sudo ln -sfn "$f" "/usr/local/bin/$(basename ${f})"
        done
    - runas: {{ user }}

# Includes hidden (.) files
qubes_s2e_dotfiles_link_home_dotfiles:
  cmd.run:
    - name: |
        find "{{ dotfiles_path }}/config" -mindepth 1 -maxdepth 1 | while read -r f; do
          ln -sfn "$f" "{{ home }}/$(basename "$f")"
        done
    - runas: {{ user }}

# Includes hidden (.) files
qubes_s2e_dotfiles_link_snippets:
  cmd.run:
    - name: |
        find "{{ dotfiles_path }}/etc/snippets" -mindepth 1 -maxdepth 1 | while read -r f; do
          ln -sfn "$f" "{{ home }}/.emacs.d/snippets/$(basename "$f")"
        done
    - runas: {{ user }}

qubes_s2e_dotfiles_link_fontconfig:
  cmd.run:
    - name: |
        ln -sfn "{{ dotfiles_path }}/etc/fonts/fonts.conf" "{{ home }}/.config/fontconfig/fonts.conf"
    - runas: {{ user }}

qubes_s2e_dotfiles_link_fonts_to_config:
  cmd.run:
    - name: |
        find "{{ dotfiles_path }}/etc/fonts" -mindepth 1 -maxdepth 1 -type d | while read -r f; do
          ln -sfn "$f" "{{ home }}/.config/fonts/truetype/$(basename "$f")"
        done
    - runas: {{ user }}

qubes_s2e_dotfiles_link_fonts_to_local_share:
  cmd.run:
    - name: |
        find "{{ dotfiles_path }}/etc/fonts" -mindepth 1 -maxdepth 1 -type d | while read -r f; do
          ln -sfn "$f" "{{ home }}/.local/share/fonts/truetype/$(basename "$f")"
        done
    - runas: {{ user }}

qubes_s2e_dotfiles_update_font_cache:
  cmd.run:
    - name: fc-cache -f
    - runas: {{ user }}
