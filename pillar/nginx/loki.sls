#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}
{% from 'nginx/macros/server_definition.sls' import server_http_80,server_https_443 with context %}
{% set secret = salt['vault'].read_secret('secret/salt/web/nginx/user') %}

include:
  - .common

nginx:
  servers:
    managed:
      loki:
        enabled: True
        authentication:
          password: {{ secret['loki'] }}|
          file: {{ defaults.authentication.file }}
          login: loki
        config:
          {% set domain_name = 'loki.whyrl.fr' %}
          {%- load_yaml as locations %}
          location /:
            - auth_basic: "Restricted"
            - auth_basic_user_file: {{ defaults.authentication.file }}
            - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
            - proxy_set_header: Host $http_host
            - proxy_pass: http://127.0.0.1:3100
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}
