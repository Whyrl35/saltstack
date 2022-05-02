# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

##
## Standalone installation
##
{% if wazuh.installation.mode == "all-in-one" %}
wazuh-auth-configuration:
  file.managed:
    - name: /var/ossec/etc/authd.pass
    - source: salt://{{ tplroot }}/files/authd.pass
    - user: root
    - group: ossec
    - mode: "0640"
    - template: jinja
    - require:
      - pkg: wazuh-install

wazuh-ossec-ar-ipset:
  file.managed:
    - name: /var/ossec/active-response/bin/ipset.sh
    - source: salt://{{ tplroot }}/files/ipset.sh
    - user: root
    - group: ossec
    - mode: "0750"
    - require:
      - pkg: wazuh-install

wazuh-ossec-ar-nftables:
  file.managed:
    - name: /var/ossec/active-response/bin/nftables-blacklist.py
    - source: salt://{{ tplroot }}/files/nftables-blacklist.py
    - user: root
    - group: ossec
    - mode: "0750"
    - require:
      - pkg: wazuh-install

wazuh-ossec-configuration:
  file.managed:
    - name: /var/ossec/etc/ossec.conf
    - source: salt://{{ tplroot }}/files/ossec.conf.server.jinja
    - user: root
    - group: ossec
    - mode: "0660"
    - template: jinja
    - context:
        ossec_config: {{ wazuh.ossec.configuration.ossec_config }}
    - require:
      - pkg: wazuh-install
{% endif %}

##
## Distributed installation (cluster)
##
{% if wazuh.installation.mode == "distributed" %}
# TODO : implement wazuh-manager-installation for distributed mode
{% endif %}
