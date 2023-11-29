# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import polemarch with context %}

polemarch-prerequisite-service:
  file.managed:
    - name: /etc/systemd/system/{{ polemarch.name }}.service
    - source: salt://polemarch/files/polemarch.systemd.jinja
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - defaults:
        polemarch: {{ polemarch }}
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: polemarch-prerequisite-service

polemarch-service-running:
  service.running:
    - name: {{ polemarch.name }}.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - ini: polemarch-configuration-file
    - require:
      - virtualenv: polemarch-virtualenv
