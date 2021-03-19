# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

##
## Standalone installation
##
{% if wazuh.installation.mode == "all-in-one" %}
elastic-service:
  service.running:
    - name: elasticsearch.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - file: elastic-configuration-file
    - require:
      - file: elastic-configuration-file

filebeat-service:
  service.running:
    - name: filebeat.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - file: filebeat-configuration
      - archive: filebeat-wazuh-module
    - require:
      - file: filebeat-configuration
      - service: elastic-service

kibana-service:
  service.running:
    - name: kibana.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - file: kibana-configuration
      - file: kibana-certs-copy-cert
      - cmd: kibana-setcap
      - cmd: kibana-plugin-install
    - require:
      - file: kibana-configuration
      - service: elastic-service
      - cmd: kibana-setcap
      - cmd: kibana-plugin-install
{% endif %}

##
## Distributed installation (cluster)
##
{% if wazuh.installation.mode == "distributed" %}
# TODO : implement wazuh-manager-installation for distributed mode
{% endif %}
