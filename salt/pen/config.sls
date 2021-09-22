# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import pen with context %}

{% for name, service in pen.services.items() %}
pen-service-{{ name }}:
  file.managed:
    - name: /etc/pen/{{ name }}.cfg
    - user: root
    - group: root
    - mode: 640
    - source: salt://pen/files/service.jinja
    - template: jinja
    - defaults:
        name: {{ name }}
        service: {{ service }}
{% endfor %}
