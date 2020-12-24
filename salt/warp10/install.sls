# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}

warp10-archive-install:
  pkg.installed:
    - names: {{ warp10.archive.deps }}
  file.directory:
    - names:
      - {{ warp10.path }}
      - {{ warp10.dir.tmp }}
