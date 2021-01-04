# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}

warp10-prerequisit-service:
  file.managed:
    - name: /etc/systemd/system/{{ warp10.name }}.service
    - source: salt://warp10/files/warp10.systemd.jinja
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - defaults:
        warp10: {{ warp10 }}
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: warp10-prerequisit-service

warp10-service-running:
  service.running:
    - name: {{ warp10.name }}.service
    - unmask: True
    - enable: True
    - reload: True
    - watch:
      - file: warp10-prerequisit-service
    - require:
      - cmd: warp10-prerequisit-service
