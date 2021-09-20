# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import glusterfs with context %}

glusterfs-client-install:
  pkg.installed:
    - name: {{ glusterfs.package.client }}
