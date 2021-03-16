# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import restic with context %}

{% if restic.prerequisit.packages %}
restic-prerequisit-install:
  pkg.installed:
    - names: {{ restic.prerequisit.packages }}
{% endif %}

restic-install:
  pkg.installed:
    - name: {{ restic.package }}
