# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import galera with context %}

galera-mariadb-enable:
  service.running:
    - name: {{ galera.mariadb.service }}
    - enable: true
    - require:
      - pkg: galera-install
    - watch:
      - file: galera-mariadb-bind
      - file: galera-config
