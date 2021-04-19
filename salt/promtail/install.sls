# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import promtail with context %}

{% if promtail.identity.user != 'root' %}
promtail-prerequisit-install:
  group.present:
    - name: {{ promtail.identity.group }}
    - system: true
  user.present:
    - name: {{ promtail.identity.user }}
    - gid: {{ promtail.identity.group }}
    - shell: /bin/bash
    - home: {{ promtail.path }}
    - createhome: false
    - system: true
    - groups:
      - {{ promtail.identity.group }}
{% endif %}

promtail-archive-install:
  pkg.installed:
    - names: {{ promtail.archive.deps }}
  file.directory:
    - names:
      - {{ promtail.path }}
      - {{ promtail.path }}/bin
      - {{ promtail.dir.tmp }}
    - user: {{ promtail.identity.user }}
    - group: {{ promtail.identity.group }}
    - mode: '0755'
    - makedirs: True
    - recurse:
        - user
        - group
        - mode
  cmd.run:
    - name: curl -Lo {{ promtail.dir.tmp }}/{{ promtail.name }}-{{ promtail.version }}.zip {{ promtail.archive.source }}
    - retry: 3
    - creates: {{ promtail.dir.tmp }}/{{ promtail.name }}-{{ promtail.version }}.zip

  service.dead:
    - name: {{ promtail.service.name }}
    - enable: False
    - init_delay: 5
    - onchanges:
      - cmd: promtail-archive-install

  archive.extracted:
    - name: {{ promtail.path }}/bin
    - source: file://{{ promtail.dir.tmp }}/{{ promtail.name }}-{{ promtail.version }}.zip
    # - use_cmd_unzip: True
    - enforce_toplevel: false
    - trim_output: True
    - overwrite: True
    # - options: "--strip-components=1"
    - user: {{ promtail.identity.user }}
    - group: {{ promtail.identity.group }}
    - onchanges:
      - cmd: promtail-archive-install
    - require:
      - service: promtail-archive-install

