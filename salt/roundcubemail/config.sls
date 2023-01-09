# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import roundcubemail with context %}

roundcubemail-configuration:
  file.managed:
    - name: {{ roundcubemail.path }}/config/config.inc.php
    - user: {{ roundcubemail.web.user }}
    - group: {{ roundcubemail.web.group }}
    - mode: '0640'
    - source: salt://roundcubemail/files/config.inc.php.jinja
    - template: jinja
    - defaults:
        config: {{ roundcubemail.config }}
