#!jinja|yaml|gpg
{% from 'galera/nodes.jinja' import nodes %}

{% set root = salt['vault'].read_secret('secret/salt/mariadb/root') %}

galera:
  nodes:
    {% for node, ips in nodes.items() %}
    {{ node }}: {{ ips }}
    {% endfor %}

  mariadb:
    root_password: {{ root['password'] }}
    server:
      config_path: /etc/mysql/mariadb.conf.d/50-server.cnf

  config_path: /etc/mysql/mariadb.conf.d/60-galera.cnf
