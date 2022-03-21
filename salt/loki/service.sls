# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import loki with context %}

loki-prerequisit-service:
  file.managed:
    - name: /etc/systemd/system/{{ loki.name }}.service
    - source: salt://loki/files/loki.systemd.jinja
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - defaults:
        loki: {{ loki }}
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: loki-prerequisit-service

loki-service-running:
  service.running:
    - name: {{ loki.name }}.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - file: loki-prerequisit-service
      - file: loki-conf-update
    - require:
      - cmd: loki-prerequisit-service
      - file: loki-conf-update
