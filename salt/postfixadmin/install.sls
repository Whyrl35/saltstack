# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import postfixadmin with context %}

postfixadmin-prerequisit-install:
  group.present:
    - name: {{ postfixadmin.identity.virtual.group }}
    - system: true
    - gid: 5000
  user.present:
    - name: {{ postfixadmin.identity.virtual.user }}
    - uid: 5000
    - gid: 5000
    - shell: /bin/bash
    - home: {{ postfixadmin.dir.home }}
    - createhome: true
    - system: true
    - nologinit: true
    - groups:
      - {{ postfixadmin.identity.virtual.group }}

postfixadmin-archive-install:
  pkg.installed:
    - names: {{ postfixadmin.archive.deps }}
  file.directory:
    - names:
      - {{ postfixadmin.path }}
      - {{ postfixadmin.dir.tmp }}
    - user: {{ postfixadmin.identity.web.user }}
    - group: {{ postfixadmin.identity.web.group }}
    - mode: '0755'
    - makedirs: True
  cmd.run:
    - name: curl -Lo {{ postfixadmin.dir.tmp }}/{{ postfixadmin.name }}-{{ postfixadmin.version }}.tar.gz {{ postfixadmin.archive.source }}
    - retry: 3
    - creates: {{ postfixadmin.dir.tmp }}/{{ postfixadmin.name }}-{{ postfixadmin.version }}.tar.gz

  archive.extracted:
    - name: {{ postfixadmin.path }}/
    - source: file://{{ postfixadmin.dir.tmp }}/{{ postfixadmin.name }}-{{ postfixadmin.version }}.tar.gz
    - format: tar
    - enforce_toplevel: false
    - trim_output: True
    - options: "--strip-components=1"
    - user: {{ postfixadmin.identity.web.user }}
    - group: {{ postfixadmin.identity.web.group }}
    - onchanges:
      - cmd: postfixadmin-archive-install
    - require:
      - cmd: postfixadmin-archive-install
