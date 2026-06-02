# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

# Template for configuring an AppVM

# Note an app qube all of the file system comes from the template
# EXCEPT /home, /usr/local, and /rw.

{# # Conditional execution based on tag search template #}
{# {% set qube_tags  = salt['pillar.get']('qubes:tags', []) %} #}
{# {% if 'my-tag' in qube_tags %} #}
{# .... #}
{# {% endif %} #}


{% set qube_type  = salt['pillar.get']('qubes:type', "UNKNOWN") %}
{# {% if qube_type == "app" %} #}
{# .... #}
{# {% endif %} #}
