# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import firezone with context %}
{%- from tplroot ~ "/macros.jinja" import format_kwargs with context %}

firezone-dependancies-install:
  pkg.installed:
    - names: {{ firezone.deps }}

firezone-repo-install:
  pkgrepo.managed:
    {{- format_kwargs(firezone.repo) }}
  require:
    - pkg: firezone-dependancies-install

firezone-install:
  pkg.installed:
    - names: {{ firezone.packages }}
  require:
    - pkgrepo: firezone-repo-install

firezone-bootstrap:
  cmd.run:
    - name: {{ firezone.cmd }} reconfigure
    - creates: {{ firezone.configuration.path }}/{{ firezone.configuration.file }}
  require:
    - pkg: firezone-install
