# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

wazuh-indexer-install-package:
  pkg.installed:
    - name: {{ wazuh.packages.indexer }}
