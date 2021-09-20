# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import glusterfs with context %}

# service that launch the backup scrit in oneshot
glusterfs-service:
  service.running:
    - name: {{ glusterfs.service.name }}
    - enable: true
    - require:
      - mount: glusterfs-fs-mounted
