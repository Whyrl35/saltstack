# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import galera with context %}

{% if galera.prerequisit.packages %}
galera-prerequisit-install:
  pkg.installed:
    - names: {{ galera.prerequisit.packages }}
{% endif %}

galera-install:
  pkg.installed:
    - name: {{ galera.package }}
