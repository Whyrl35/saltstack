# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}

warp10-archive-install:
  pkg.installed:
    - names: {{ warp10.archive.deps }}
  file.directory:
    - names:
      - {{ warp10.path }}
      - {{ warp10.dir.tmp }}
    - user: {{ warp10.identity.rootuser }}
    - group: {{ warp10.identity.rootgroup }}
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
    - enforce_toplevel: firewalld.service:
    - trim_output: True
    - user: {{ warp10.identity.rootuser }}
    - group: {{ warp10.identity.rootgroup }}
    - onchanges:
      - cmd: warp10-archive-install
    - require:
      - cmd: warp10-archive-install
