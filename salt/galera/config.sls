# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import galera with context %}

{% set ips = galera.nodes.values() | sum(start=[]) | join(',') %}

#galera-mariadb-user-root:
  #  mysql_user.present:
    #  - name: root
    #- host: localhost
    #- allow_passwordless: False
    #- password: {{ galera.mariadb.root_password }}

galera-mariadb-bind:
  file.keyvalue:
    - name: {{ galera.mariadb.server.config_path }}
    - key_values:
        bind-address: {{ grains['ip4_interfaces']['ens4'][0] }}
    - separator: '='
    - uncomment: '#'
    - append_if_not_found: True

galera-config:
  file.keyvalue:
    - name: {{ galera.config_path }}
    - key_values:
        bind-address: {{ grains['ip4_interfaces']['ens4'][0] }}
        wsrep_on: 'ON'
        wsrep_cluster_address: gcomm://{{ ips }}
        wsrep_cluster_name: galera_cluster
        wsrep_provider: /usr/lib/galera/libgalera_smm.so
        wsrep_sst_method: rsync
        default_storage_engine: InnoDB
        innodb_autoinc_lock_mode: 2
        innodb_doublewrite: 1
        binlog_format: row
    - separator: '='
    - uncomment: '#'
    - append_if_not_found: True
