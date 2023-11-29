#!jinja|yaml|gpg

{% from 'nginx/macros/server_definition.sls' import server_http_80,server_https_443 with context %}

include:
  - .common

nginx:
  servers:
    managed:
      bitwarden:
        enabled: True
        config:
          {% set domain_name = 'warden.whyrl.fr' %}
          {%- load_yaml as locations %}
          location /:
            - proxy_set_header: 'Upgrade $http_upgrade'
            - proxy_set_header: 'Connection "upgrade"'
            - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
            - proxy_set_header: 'X-Forwarded-Proto $scheme'
            - proxy_set_header: 'Host $host'
            - proxy_redirect: "'off'"
            - proxy_http_version: 1.1
            - proxy_pass: 'http://127.0.0.1:8080'
          {%- endload %}

          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}

          #
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      grafana:
        enabled: True
        config:
          {% set domain_name = 'grafana.whyrl.fr' %}
          {%- load_yaml as locations %}
          location /:
            - proxy_set_header: 'Upgrade $http_upgrade'
            - proxy_set_header: 'Connection "upgrade"'
            - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
            - proxy_set_header: 'X-Forwarded-Proto $scheme'
            - proxy_set_header: 'Host $host'
            - proxy_redirect: "'off'"
            - proxy_http_version: 1.1
            - proxy_pass: 'http://127.0.0.1:3000'
          {%- endload %}

          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}

          #
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      alcali:
        enabled: True
        config:
          {% set domain_name = 'alcali.whyrl.fr' %}
          {%- load_yaml as locations %}
          location /:
            - proxy_set_header: 'Upgrade $http_upgrade'
            - proxy_set_header: 'Connection "upgrade"'
            - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
            - proxy_set_header: 'X-Forwarded-Proto $scheme'
            - proxy_set_header: 'Host $host'
            - proxy_redirect: "'off'"
            - proxy_http_version: 1.1
            - proxy_pass: 'http://127.0.0.1:8000'
            - proxy_connect_timeout: 1200
            - proxy_send_timeout: 600
            - proxy_read_timeout: 600
            - send_timeout: 600
          {%- endload %}

          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}

          #
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      docuseal:
        enabled: True
        config:
          {% set domain_name = 'docuseal.whyrl.fr' %}
          {%- load_yaml as locations %}
          location /:
            - proxy_set_header: 'Upgrade $http_upgrade'
            - proxy_set_header: 'Connection "upgrade"'
            - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
            - proxy_set_header: 'X-Forwarded-Proto $scheme'
            - proxy_set_header: 'Host $host'
            - proxy_redirect: "'off'"
            - proxy_http_version: 1.1
            - proxy_pass: 'http://127.0.0.1:9110'
            - proxy_connect_timeout: 1200
            - proxy_send_timeout: 600
            - proxy_read_timeout: 600
            - send_timeout: 600
          {%- endload %}

          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}

          #
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}
