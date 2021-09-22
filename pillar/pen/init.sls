#!jinja|yaml|gpg
{% from 'galera/nodes.jinja' import nodes %}

pen:
  services:
    mariadb:
      servers:
      {% for node, ips in nodes.items() %}
        - server: {{ node }}
          ip: {{ ips[0] }}
          port: 3306
      {% endfor %}
      port: 3306
      ip: 127.0.0.1
