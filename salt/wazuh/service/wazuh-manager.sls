# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

##
## Standalone installation
##
{% if wazuh.installation.mode == "all-in-one" %}
wazuh-service-running:
  service.running:
    - name: wazuh-manager.service
    - unmask: True
    - enable: True
    - reload: False
    - watch:
      - file: wazuh-ossec-configuration
    - require:
      - file: wazuh-ossec-configuration
{% endif %}

##
## Distributed installation (cluster)
##
{% if wazuh.installation.mode == "distributed" %}
# TODO : implement wazuh-manager-installation for distributed mode
{% endif %}

