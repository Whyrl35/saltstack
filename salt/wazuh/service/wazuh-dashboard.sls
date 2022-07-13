# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

wazuh-dashboard-service-running:
  service.running:
    - name: wazuh-dashboard.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - file: wazuh-ossec-configuration
    - require:
      - file: wazuh-ossec-configuration
