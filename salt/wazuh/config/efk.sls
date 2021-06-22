# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

{% set sh_elastic_conf = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.elasticsearch.configuration.source ~ ' | md5sum | cut -c -32`"') %}
{% set sh_elastic_roles = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.elasticsearch.roles.source ~ ' | md5sum | cut -c -32`"') %}
{% set sh_elastic_roles_mapping = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.elasticsearch.roles_mapping.source ~ ' | md5sum | cut -c -32`"') %}
{% set sh_elastic_users = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.elasticsearch.users.source ~ ' | md5sum | cut -c -32`"') %}
{% set sh_search_guard_binary = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.search_guard.binary.source ~ ' | md5sum | cut -c -32`"') %}
{% set sh_search_guard_configuration = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.search_guard.configuration.source ~ ' | md5sum | cut -c -32`"') %}
{% set sh_filebeat_conf = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.filebeat.configuration.source ~ ' | md5sum | cut -c -32`"') %}
{% set sh_filebeat_alerts = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.filebeat.alerts.source ~ ' | md5sum | cut -c -32`"') %}
{% set sh_filebeat_module = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.filebeat.module.source ~ ' | md5sum | cut -c -32`"') %}
{% set sh_kibana_conf = salt['cmd.shell']('echo "md5=`curl -s ' ~ wazuh.kibana.configuration.source ~ ' | md5sum | cut -c -32`"') %}

##
## Standalone installation
##
{% if wazuh.installation.mode == "all-in-one" %}
elastic-configuration-file:
  file.managed:
    - name: {{ wazuh.elasticsearch.configuration.destination }}
    - source: {{ wazuh.elasticsearch.configuration.source }}
    - source_hash: {{ sh_elastic_conf }}
    - user: {{ wazuh.elasticsearch.user }}
    - group: {{ wazuh.elasticsearch.group }}
    - mode: '0660'
    - require:
      - pkg: efk-opendistro-install

elastic-roles-file:
  file.managed:
    - name: {{ wazuh.elasticsearch.roles.destination }}
    - source: {{ wazuh.elasticsearch.roles.source }}
    - source_hash: {{ sh_elastic_roles }}
    - user: {{ wazuh.elasticsearch.user }}
    - group: {{ wazuh.elasticsearch.group }}
    - mode: '0660'
    - require:
      - pkg: efk-opendistro-install

elastic-roles-mapping-file:
  file.managed:
    - name: {{ wazuh.elasticsearch.roles_mapping.destination }}
    - source: {{ wazuh.elasticsearch.roles_mapping.source }}
    - source_hash: {{ sh_elastic_roles_mapping }}
    - user: {{ wazuh.elasticsearch.user }}
    - group: {{ wazuh.elasticsearch.group }}
    - mode: '0660'
    - require:
      - pkg: efk-opendistro-install

elastic-users-file:
  file.managed:
    - name: {{ wazuh.elasticsearch.users.destination }}
    - source: {{ wazuh.elasticsearch.users.source }}
    - source_hash: {{ sh_elastic_users }}
    - user: {{ wazuh.elasticsearch.user }}
    - group: {{ wazuh.elasticsearch.group }}
    - mode: '0660'
    - require:
      - pkg: efk-opendistro-install

elastic-remove-demo-cert:
  file.absent:
    - names:
      - /etc/elasticsearch/esnode-key.pem
      - /etc/elasticsearch/esnode.pem
      - /etc/elasticsearch/kirk-key.pem
      - /etc/elasticsearch/kirk.pem
      - /etc/elasticsearch/root-ca.pem
    - require:
      - pkg: efk-opendistro-install

elastic-certs-directory:
  file.directory:
    - name: {{ wazuh.elasticsearch.configuration.certs }}
    - user: {{ wazuh.elasticsearch.user }}
    - group: {{ wazuh.elasticsearch.group }}
    - mode: '4755'
    - require:
      - pkg: efk-opendistro-install

elastic-search-guard-bin:
  archive.extracted:
    - name: {{ wazuh.search_guard.binary.destination }}
    - source: {{ wazuh.search_guard.binary.source }}
    - source_hash: {{ sh_search_guard_binary }}
    - enforce_toplevel: False
    - if_missing: {{ wazuh.search_guard.binary.destination }}
    - require:
      - pkg: efk-opendistro-install

elastic-search-guard-conf:
  file.managed:
    - name: {{ wazuh.search_guard.configuration.destination }}
    - source: {{ wazuh.search_guard.configuration.source }}
    - source_hash: {{ sh_search_guard_configuration }}
    - require:
      - archive: elastic-search-guard-bin

elastic-search-guard-generate-cert:
  cmd.run:
    - name: |
        {{ wazuh.search_guard.binary.destination }}/tools/sgtlstool.sh -c {{ wazuh.search_guard.configuration.destination }} \
          -ca -crt -t {{ wazuh.elasticsearch.configuration.certs }} && \
          echo && \
          echo "changed=yes comment='New cert created'"
    - creates: {{ wazuh.elasticsearch.configuration.certs }}/elasticsearch.key
    - require:
      - file: elastic-search-guard-conf

elastic-securityadmin:
  cmd.run:
    - name: |
        {{ wazuh.elasticsearch.securityadmin.path }} -cd {{ wazuh.elasticsearch.securityadmin.plugin }} \
          -nhnv -cacert {{ wazuh.elasticsearch.configuration.certs }}/root-ca.pem \
          -cert {{ wazuh.elasticsearch.configuration.certs }}/admin.pem \
          -key {{ wazuh.elasticsearch.configuration.certs }}/admin.key
    - onchanges:
      - cmd: elastic-search-guard-generate-cert
    - require:
      - service: elastic-service

filebeat-configuration:
  file.managed:
    - name: {{ wazuh.filebeat.configuration.destination }}
    - source: {{ wazuh.filebeat.configuration.source }}
    - source_hash: {{ sh_filebeat_conf }}
    - user: {{ wazuh.filebeat.user }}
    - group: {{ wazuh.filebeat.group }}
    - mode: '0600'
    - replace: false
    - require:
      - pkg: efk-opendistro-install

filebeat-alerts:
  file.managed:
    - name: {{ wazuh.filebeat.alerts.destination }}
    - source: {{ wazuh.filebeat.alerts.source }}
    - source_hash: {{ sh_filebeat_alerts }}
    - user: {{ wazuh.filebeat.user }}
    - group: {{ wazuh.filebeat.group }}
    - mode: '0644'
    - require:
      - file: filebeat-configuration

filebeat-wazuh-module:
  archive.extracted:
    - name: {{ wazuh.filebeat.module.destination }}
    - source: {{ wazuh.filebeat.module.source }}
    - source_hash: {{ sh_filebeat_module }}
    - user: {{ wazuh.filebeat.user }}
    - group: {{ wazuh.filebeat.group }}
    - if_missing: {{ wazuh.filebeat.module.destination }}/wazuh
    - require:
      - file: filebeat-alerts

filebeat-certs-directory:
  file.directory:
    - name: {{ wazuh.filebeat.configuration.certs }}
    - user: {{ wazuh.filebeat.user }}
    - group: {{ wazuh.filebeat.group }}
    - mode: '0755'
    - require:
      - file: filebeat-configuration

filebeat-certs-copy-ca:
  file.copy:
    - name: {{ wazuh.filebeat.configuration.certs }}
    - user: {{ wazuh.filebeat.user }}
    - group: {{ wazuh.filebeat.group }}
    - mode: '0640'
    - source: {{ wazuh.elasticsearch.configuration.certs }}/root-ca.pem
    - require:
      - file: filebeat-certs-directory

filebeat-certs-copy-cert-key:
  file.copy:
    - name: {{ wazuh.filebeat.configuration.certs }}
    - user: {{ wazuh.filebeat.user }}
    - group: {{ wazuh.filebeat.group }}
    - mode: '0640'
    - source: {{ wazuh.elasticsearch.configuration.certs }}/filebeat.key
    - require:
      - file: filebeat-certs-directory

filebeat-certs-copy-cert:
  file.copy:
    - name: {{ wazuh.filebeat.configuration.certs }}
    - user: {{ wazuh.filebeat.user }}
    - group: {{ wazuh.filebeat.group }}
    - mode: '0640'
    - source: {{ wazuh.elasticsearch.configuration.certs }}/filebeat.pem
    - require:
      - file: filebeat-certs-directory

kibana-configuration:
  file.managed:
    - name: {{ wazuh.kibana.configuration.destination }}
    - source: {{ wazuh.kibana.configuration.source }}
    - source_hash: {{ sh_kibana_conf }}
    - user: {{ wazuh.kibana.user }}
    - group: {{ wazuh.kibana.group }}
    - mode: '0644'
    - replace: false
    - require:
      - pkg: efk-opendistro-install

kibana-data-directory:
  file.directory:
    - name: {{ wazuh.kibana.data.path }}
    - user: {{ wazuh.kibana.data.user }}
    - group: {{ wazuh.kibana.data.group }}
    - mode: '0755'
    - require:
      - file: kibana-configuration

kibana-plugin-install:
  cmd.run:
    - name: {{ wazuh.kibana.plugin.binary }} install {{ wazuh.kibana.plugin.wazuh_plugin }}
    - creates: {{ wazuh.kibana.plugin.created }}
    - require:
      - file: kibana-data-directory

kibana-certs-directory:
  file.directory:
    - name: {{ wazuh.kibana.configuration.certs }}
    - user: {{ wazuh.kibana.user }}
    - group: {{ wazuh.kibana.group }}
    - mode: '0755'
    - require:
      - file: kibana-configuration

kibana-certs-copy-ca:
  file.copy:
    - name: {{ wazuh.kibana.configuration.certs }}
    - user: {{ wazuh.kibana.user }}
    - group: {{ wazuh.kibana.group }}
    - mode: '0640'
    - source: {{ wazuh.elasticsearch.configuration.certs }}/root-ca.pem
    - require:
      - file: kibana-certs-directory

kibana-certs-copy-cert-key:
  file.copy:
    - name: {{ wazuh.kibana.configuration.certs }}
    - user: {{ wazuh.kibana.user }}
    - group: {{ wazuh.kibana.group }}
    - mode: '0640'
    - source: {{ wazuh.elasticsearch.configuration.certs }}/kibana.key
    - require:
      - file: kibana-certs-directory

kibana-certs-copy-cert:
  file.copy:
    - name: {{ wazuh.kibana.configuration.certs }}
    - user: {{ wazuh.kibana.user }}
    - group: {{ wazuh.kibana.group }}
    - mode: '0640'
    - source: {{ wazuh.elasticsearch.configuration.certs }}/kibana.pem
    - require:
      - file: kibana-certs-directory

kibana-setcap:
  cmd.run:
    - name: setcap 'cap_net_bind_service=+ep' /usr/share/kibana/node/bin/node
    - unless: getcap /usr/share/kibana/node/bin/node | grep -q 'cap_net_bind_service+ep'
    - require:
      - file: kibana-certs-copy-cert
      - file: kibana-configuration

{% endif %}

##
## Distributed installation (cluster)
##
{% if wazuh.installation.mode == "distributed" %}
# TODO : implement wazuh-manager-installation for distributed mode
{% endif %}
