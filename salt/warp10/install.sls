# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}

warp10-prerequisit-install:
  group.present:
    - name: {{ warp10.identity.group }}
    - system: true
  user.present:
    - name: {{ warp10.identity.user }}
    - gid: {{ warp10.identity.group }}
    - shell:
    - home: {{ warp10.path }}
    - createhome: false
    - system: true
    - groups:
      - {{ warp10.identity.group }}

warp10-archive-install:
  pkg.installed:
    - names: {{ warp10.archive.deps }}
  file.directory:
    - names:
      - {{ warp10.path }}
      - {{ warp10.dir.tmp }}
    - user: {{ warp10.identity.user }}
    - group: {{ warp10.identity.group }}
    - mode: '0755'
    - makedirs: True
#    - require_in:
#      - archive: java-package-archive-install
    - recurse:
        - user
        - group
        - mode
  cmd.run:
    - name: curl -Lo {{ warp10.dir.tmp }}/warp10-archive.tar.gz {{ warp10.archive.source }}
    - retry: 3
    - unless:
      - test -f {{ warp10.dir.tmp }}/warp10-archive.tar.gz
  archive.extracted:
    - name: {{ warp10.path }}/
    - source: file://{{ warp10.dir.tmp }}/warp10-archive.tar.gz
    - format: tar
    - enforce_toplevel: false
    - trim_output: True
    - options: "--strip-components=1"
    - user: {{ warp10.identity.user }}
    - group: {{ warp10.identity.group }}
    - onchanges:
      - cmd: warp10-archive-install
    - require:
      - cmd: warp10-archive-install

warp10-bootstrap-standalone:
  cmd.run:
    - name: {{ warp10.path }}/bin/warp10-standalone.init bootstrap
    - unless:
        - find {{ warp10.path }}/etc/conf.d -not -path "*\/.*" -name "*.conf"
