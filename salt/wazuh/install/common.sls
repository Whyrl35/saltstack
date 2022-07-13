# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

wazuh-indexer-install-dependencies:
  pkg.installed:
    - names: {{ wazuh.packages.dependencies }}

wazuh-indexer-adding-repository:
  pkgrepo.managed:
    - name: deb https://packages.wazuh.com/4.x/apt/ stable main
    - file: /etc/apt/sources.list.d/wazuh.list
    - key_url: https://packages.wazuh.com/key/GPG-KEY-WAZUH
