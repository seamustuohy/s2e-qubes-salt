{% set qube_tags  = salt['pillar.get']('qubes:tags', []) %}
{% set qube_type  = salt['pillar.get']('qubes:type', "UNKNOWN") %}

{% if qube_type == "app" %}
{% if 'mail-cold-storage' in qube_tags %}
qubes-s2e-neomutt-store_transferred_cold_storage:
  file.managed:
    - name: /home/user/.mutt/scripts/store_transferred_in_cold_storage.sh
    - source: salt://qubes-s2e-neomutt/files/store_transferred_in_cold_storage.sh
    - mode: "0755"
    - user: user
    - group: user
    - makedirs: True

qubes-s2e-neomutt-appvm-cold-storage-cron:
  cron.present:
    - name: "/home/user/.mutt/scripts/store_transferred_in_cold_storage.sh > /tmp/CS_last_run.log 2>&1"
    - user: "user"
    - minute: '*/5'

{% endif %}
{% endif %}
