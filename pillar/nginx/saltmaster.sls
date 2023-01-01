#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}
{% from 'nginx/macros/server_definition.sls' import server_http_80,server_https_443 with context %}

include:
  - .common

nginx:
  servers:
    managed:
      vault:
        enabled: True
        config:
          {% set domain_name = 'vault.whyrl.fr' %}
          {%- load_yaml as locations %}
          location /:
            - proxy_set_header: 'Upgrade $http_upgrade'
            - proxy_set_header: 'Connection "upgrade"'
            - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
            - proxy_set_header: 'X-Forwarded-Proto $scheme'
            - proxy_set_header: X-Real-IP $remote_addr
            - proxy_set_header: 'Host $host'
            - proxy_redirect: "'off'"
            - proxy_http_version: 1.1
            - proxy_pass: 'https://vault.cloud.whyrl.fr:8200'
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      saltgui:
        enabled: True
        config:
          {% set domain_name = 'saltgui.whyrl.fr' %}
          {%- load_yaml as options %}
            - root: '/opt/SaltGUI/saltgui'
          {%- endload %}
          {%- load_yaml as locations %}
            location /api/:
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_ssl_session_reuse: "'off'"
              - proxy_set_header: Host $http_host
              - proxy_redirect: "'off'"
              - proxy_pass: 'http://127.0.0.1:3333/'
            location /:
              - try_files:
                - '$uri /index.html'
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations, options) | indent(11) }}
