# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}

warpfleet-install:
  pkg.installed:
    - names: {{ warp10.archive.deps }}
  cmd.run:
    - name: {{ warp10.warpfleet.install_cmd }}
    - unless: {{ warp10.warpfleet.binary }} -v
