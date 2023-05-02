# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import roundcubemail with context %}

roundcubemail-archive-install:
  pkg.installed:
    - names: {{ roundcubemail.package.deps }}
  file.directory:
    - names:
      - {{ roundcubemail.path }}
      - {{ roundcubemail.package.tmp }}
    - user: {{ roundcubemail.web.user }}
    - group: {{ roundcubemail.web.group }}
    - mode: '0755'
    - makedirs: True
    - recurse:
        - user
        - group
  cmd.run:
    - name: curl -Lo {{ roundcubemail.package.tmp }}/{{ roundcubemail.name }}-{{ roundcubemail.package.version }}-complete.tar.gz {{ roundcubemail.package.url }}/{{ roundcubemail.package.version }}/{{ roundcubemail.name }}-{{ roundcubemail.package.version }}-complete.tar.gz  # noqa: 204
    - retry: 3
    - creates: {{ roundcubemail.package.tmp }}/{{ roundcubemail.name }}-{{ roundcubemail.package.version }}-complete.tar.gz

  archive.extracted:
    - name: {{ roundcubemail.path }}
    - source: file://{{ roundcubemail.package.tmp }}/{{ roundcubemail.name }}-{{ roundcubemail.package.version }}-complete.tar.gz
    - enforce_toplevel: false
    - trim_output: True
    - overwrite: True
    # - options: "--strip-components=1"
    - user: {{ roundcubemail.web.user }}
    - group: {{ roundcubemail.web.group }}
    - onchanges:
      - cmd: roundcubemail-archive-install

roundcubemail-install-temp:
  file.directory:
    - name: {{ roundcubemail.path }}/temp
    - user: {{ roundcubemail.web.user }}
    - group: {{ roundcubemail.web.group }}
    - mode: '0755'

roundcubemail-install-logs:
  file.directory:
    - name: {{ roundcubemail.path }}/logs
    - user: {{ roundcubemail.web.user }}
    - group: {{ roundcubemail.web.group }}
    - mode: '0755'
