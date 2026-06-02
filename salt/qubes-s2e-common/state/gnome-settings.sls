{% set node = grains.get("nodename", "") %}
# gsettings get org.gnome.nautilus.list-view default-visible-columns
{% set user = pillar.get("local_user", "") %}

# gsettings list-schemas
# https://github.com/SEJeff/salt-states/blob/master/macros.sls
# Set a key with gsettings for configuring a GNOME 3 desktop
{% macro gsettings(node, user, path, key, value, regex) -%}
gsettings_set_{{ node }}_{{ path }}_{{ key }}:
  cmd.run:
    - cwd: /
    - name: gsettings set {{ path }} {{ key }} {{ value }}
    - user: {{ user }}
    - unless: gsettings get {{ path }} {{ key }} | grep -q {{ regex }}
{%- endmacro %}

#  === FILE BROWSER: GTK FileChooser & Nautilus desktop settings ====
## https://gitlab.gnome.org/GNOME/gtk/-/blob/c925221aa804aec344bdfec148a17d23299b6c59/gtk/org.gtk.Settings.FileChooser.gschema.xml
## Show file picker columns I care about.
{{ gsettings(node, user, "org.gnome.nautilus.list-view", "default-visible-columns", "\"['name', 'size', 'date_modified', 'type', 'detailed_type']\"", "^\['name', 'size', 'date_modified', 'type', 'detailed_type'\]$") }}

## Sort Columns
{{ gsettings(node, user, "org.gtk.Settings.FileChooser", "sort-column", "'name'", "^'name'$") }}
{{ gsettings(node, user, "org.gnome.nautilus.preferences", "default-sort-order", "'name'", "^'name'$") }}

## Set directory first sorting for Nautilus in GTK Settings, and GTK4 Settings
{# # {{ gsettings(user, "org.gnome.nautilus.preferences", "sort-directories-first", "true", '^true$') }} #}
{{ gsettings(node, user, "org.gtk.Settings.FileChooser", "sort-directories-first", "true", '^true$') }}
{{ gsettings(node, user, "org.gtk.gtk4.Settings.FileChooser", "sort-directories-first", "true", '^true$') }}

## Allow me to interact with the file path like a file path
{{ gsettings(node, user, "org.gtk.gtk4.Settings.FileChooser", "location-mode", "'filename-entry'", "^'filename-entry'$") }}
{{ gsettings(node, user, "org.gnome.nautilus.preferences", "always-use-location-entry", "true", '^true$') }}
