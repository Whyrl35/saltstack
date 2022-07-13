# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

wazuh-manager-service-running:
  service.running:
    - name: wazuh-manager.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - file: wazuh-ossec-configuration
    - require:
      - file: wazuh-ossec-configuration

wazuh-manager-filebeat-service-running:
  service.running:
    - name: filebeat.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - file: wazuh-ossec-configuration
    - require:
      - file: wazuh-ossec-configuration
