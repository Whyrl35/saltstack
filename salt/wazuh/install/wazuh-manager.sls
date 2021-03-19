# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

# INFO : wazuh repository is globally managed for now via a formula (apt for debian). You must managed it via an external formula corresponding to your OS

##
## Standalone installation
##
{% if wazuh.installation.mode == "all-in-one" %}
wazuh-prerequisit-install:
  pkg.installed:
    - names: {{ wazuh.installation.dependancies }}

wazuh-install:
  pkg.installed:
    - name: wazuh-manager
{% endif %}

##
## Distributed installation (cluster)
##
{% if wazuh.installation.mode == "distributed" %}
# TODO : implement wazuh-manager-installation for distributed mode
{% endif %}
