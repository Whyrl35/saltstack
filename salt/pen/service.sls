# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import pen with context %}

{% for name, service in pen.services.items() %}
pen-systemd-{{ name }}:
  file.managed:
    - name: /etc/systemd/system/pen-{{ name }}.service
    - source: salt://pen/files/systemd.jinja
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - defaults:
        name: {{ name }}
        service: {{ service }}
    - require:
      - file: pen-service-{{ name }}
  service.running:
    - name: pen-{{ name }}.service
    - enable: true
    - require:
      - file: pen-systemd-{{ name }}
    - onchanges:
      - file: /etc/systemd/system/pen-*
{% endfor %}

# refresh systemd when there is change on above files
pen-refresh-systemd:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/pen-*
