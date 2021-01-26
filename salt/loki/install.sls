# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import loki with context %}

loki-prerequisit-install:
  group.present:
    - name: {{ loki.identity.group }}
    - system: true
  user.present:
    - name: {{ loki.identity.user }}
    - gid: {{ loki.identity.group }}
    - shell: /bin/bash
    - home: {{ loki.path }}
    - createhome: false
    - system: true
    - groups:
      - {{ loki.identity.group }}

loki-archive-install:
  pkg.installed:
    - names: {{ loki.archive.deps }}
  file.directory:
    - names:
      - {{ loki.path }}
      - {{ loki.path }}/bin
      - {{ loki.dir.tmp }}
    - user: {{ loki.identity.user }}
    - group: {{ loki.identity.group }}
    - mode: '0755'
    - makedirs: True
    - recurse:
        - user
        - group
        - mode
  cmd.run:
    - name: curl -Lo {{ loki.dir.tmp }}/{{ loki.name }}-{{ loki.version }}.zip {{ loki.archive.source }}
    - retry: 3
    - creates: {{ loki.dir.tmp }}/{{ loki.name }}-{{ loki.version }}.zip

  archive.extracted:
    - name: {{ loki.path }}/bin
    - source: file://{{ loki.dir.tmp }}/{{ loki.name }}-{{ loki.version }}.zip
    # - use_cmd_unzip: True
    - enforce_toplevel: false
    - trim_output: True
    # - options: "--strip-components=1"
    - user: {{ loki.identity.user }}
    - group: {{ loki.identity.group }}
    - onchanges:
      - cmd: loki-archive-install
    - require:
      - cmd: loki-archive-install

