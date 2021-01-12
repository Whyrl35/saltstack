# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}

warpfleet-install:
  pkg.installed:
    - names: {{ warp10.warpfleet.deps }}
  cmd.run:
    - name: {{ warp10.warpfleet.install_cmd }}
    - creates:
      - '/usr/local/lib/node_modules/@senx/warpfleet/'
