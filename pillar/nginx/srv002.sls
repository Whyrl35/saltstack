#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}
{% from 'nginx/macros/server_definition.sls' import server_http_80,server_https_443 with context %}

include:
  - .common

nginx:
  servers:
    managed:
      nas:
        enabled: True
        config:
          {% set domain_name = 'nas.whyrl.fr' %}
          {%- load_yaml as locations %}
            location /:
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: Host $http_host
              - proxy_pass: https://192.168.0.2:5001
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"
              - proxy_read_timeout: 600
              - client_max_body_size: 1024M
            location /photo/:
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: Host $http_host
              - proxy_pass: https://192.168.0.2/photo/
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"
              - proxy_read_timeout: 600
              - client_max_body_size: 1024M
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      portainer:
        enabled: True
        config:
          {% set domain_name = 'portainer.whyrl.fr' %}
          {%- load_yaml as locations %}
            location /:
              - proxy_set_header: Host $host
              - proxy_pass: http://192.168.0.3:9000  # http://127.0.0.1:9000
              - proxy_http_version: 1.1
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      hassio:
        enabled: True
        config:
          {% set domain_name = 'hassio.whyrl.fr' %}
          {%- load_yaml as locations %}
            location /:
              - proxy_pass: http://127.0.0.1:8123
              - proxy_http_version: 1.1
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"
              - proxy_set_header: Host $host
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
            location /api/websocket:
              - proxy_pass: http://127.0.0.1:8123/api/websocket
              - proxy_http_version: 1.1
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"
              - proxy_set_header: Host $host
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      gateway:
        enabled: True
        config:
          {% set domain_name = 'gateway.whyrl.fr' %}
          {%- load_yaml as locations %}
            location /:
              - proxy_pass: http://192.168.0.254
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      default:
        enabled: True
        config:
          {% set domain_name = 'whyrl.fr www.whyrl.fr' %}
          {%- load_yaml as options %}
            - root: /var/www/website/
            - index: index.html index.htm
            - charset: {{ defaults.charset }}
            - ssl_session_cache: shared:SSL:10m
          {%- endload %}
          {%- load_yaml as locations %}
            location /:
              - try_files:
                - '$uri /index.html'
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations, options) | indent(11) }}
