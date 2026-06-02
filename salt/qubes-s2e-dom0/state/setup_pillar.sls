# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

{% import_yaml "/srv/user_pillar/top.sls" as top %}

template-mullvadvpn_set_pillar_in_top:
  file.serialize:
    - name: /srv/user_pillar/top.sls
    - merge_if_exists: true
    - dataset:
        user:
          "*":
            - dom0.default
    - formatter: yaml
