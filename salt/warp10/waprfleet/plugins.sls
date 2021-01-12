# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}

{% if warp10.version | version_compare('2.1.0', '<') %}
{% set default_options = "-w " + warp10.path %}
{% else %}
{% set default_options = "--confDir=" + warp10.path +  "/etc/conf.d --macroDir=" + warp10.path + "/macros/ --libDir=" + warp10.path + "/libs" %}
{% endif %}

{% for plugin in warp10.warpfleet.plugins %}
plugins-install-{{ plugin }}:
  cmd.run:
    - name: {{ warp10.warpfleet.binary }} g {{ warp10.warpfleet.plugins[plugin].repository }} {{ plugin }} {{ default_options }}
    - unless: ""
{% endfor %}
