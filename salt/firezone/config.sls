# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import firezone with context %}

firezone-config:
  file.managed:
    - name: {{ firezone.configuration.path }}/{{ firezone.configuration.file }}
    - source: salt://{{ tplroot }}/files/firezone.rb.jinja
    - template: jinja
    - context:
        config: {{ firezone.configuration.data }}
    - require:
      - cmd: firezone-bootstrap

firezone-config-reconfigure:
  cmd.run:
    - name: {{ firezone.cmd }} reconfigure
    - onchanges:
      - file: firezone-config
