# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

# INFO : wazuh repository is globally managed for now via a formula (apt for debian). You must managed it via an external formula corresponding to your OS
# INFO : to find java for debian, you must activate the backports via the apt formula or manualy
# INFO : for now jdk is installed as a dependancy, it may be wise to migrate and install it via the java formula (will support more OS)

##
## Standalone installation
##
{% if wazuh.installation.mode == "all-in-one" %}
efk-opendistro-install:
  pkg.installed:
    - names: {{ wazuh.installation.opendistro }}

# TODO : implement native elastic stack instead of opendistro (amazon) one

{% endif %}

##
## Distributed installation (cluster)
##
{% if wazuh.installation.mode == "distributed" %}
# TODO : implement wazuh-manager-installation for distributed mode
{% endif %}
