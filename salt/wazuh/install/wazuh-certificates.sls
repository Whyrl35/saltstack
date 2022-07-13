# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

certificates-creation-get-certs-tool:
  cmd.run:
    - name: curl -s https://packages.wazuh.com/{{ wazuh['version'] }}/wazuh-certs-tool.sh -o /var/tmp/wazuh-certs-tools.sh
    - creates: /var/tmp/wazuh-certs-tools.sh

certificates-creation-get-certs-config:
  cmd.run:
    - name: curl -s https://packages.wazuh.com/{{ wazuh['version'] }}/config.yml -o /var/tmp/config.yml
    - creates: /var/tmp/wazuh-certs-tools.sh

# TODO : generate the certificate and propagate them
# c.f. : https://documentation.wazuh.com/current/installation-guide/wazuh-indexer/step-by-step.html


