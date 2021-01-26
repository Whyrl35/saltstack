# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import promtail with context %}

promtail-prerequisit-service:
  file.managed:
    - name: /etc/systemd/system/{{ promtail.name }}.service
    - source: salt://promtail/files/promtail.systemd.jinja
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - defaults:
        promtail: {{ promtail }}
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: promtail-prerequisit-service

promtail-service-running:
  service.running:
    - name: {{ promtail.name }}.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - file: promtail-prerequisit-service
    - require:
      - cmd: promtail-prerequisit-service

