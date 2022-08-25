# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import firezone with context %}

firezone-service-running:
  service.running:
    - name: {{ firezone.service_name }}.service
    - unmask: True
    - enable: True
    - reload: False
