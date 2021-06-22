# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}
{%- set wf = warp10.warpfleet -%}

{% if salt.pkg_resource.version_compare(warp10.version, '<=', '2.1.0') %}
{% set default_options = "-w " + warp10.path %}
{% else %}
{% set default_options = "--confDir=" + warp10.path +  "/etc/conf.d --macroDir=" + warp10.path + "/macros/ --libDir=" + warp10.path + "/lib" %}
{% endif %}

{% for plugin in wf.plugins %}
plugins-install-{{ plugin }}:
  cmd.run:
    - name: {{ wf.binary }} get {{ default_options }} {{ wf.plugins[plugin].repository }} {{ plugin }} {{ wf.plugins[plugin].version }}
    - creates:
      - {{ warp10.path }}/lib/{{ wf.plugins[plugin].file_to_check }}
{% endfor %}
