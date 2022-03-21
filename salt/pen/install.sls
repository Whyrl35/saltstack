# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import pen with context %}

pen-install:
  pkg.installed:
    - name: {{ pen.package }}

pen-configuration:
  file.directory:
    - name: /etc/{{ pen.name }}
    - user: root
    - group: root
    - dir_mode: '0750'
    - file_mode: '0640'

pen-log:
  file.directory:
    - name: /var/log/{{ pen.name }}
    - user: root
    - group: root
    - dir_mode: '0755'
    - file_mode: '0644'

pen-pid:
  file.directory:
    - name: /run/{{ pen.name }}
    - user: root
    - group: root
    - dir_mode: '0755'
    - file_mode: '0644'0
