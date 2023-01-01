#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}
{% from 'nginx/macros/server_definition.sls' import server_http_80,server_https_443 with context %}

include:
  - .common

nginx:
  servers:
    managed:
      default:
        enabled: True
        config:
          {% set domain_name = 'ks.whyrl.fr' %}
          {%- load_yaml as options %}
            - root: /var/www/website/
            - index: index.html index.htm
            - charset: {{ defaults.charset }}
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

      drone:
        enabled: True
        config:
          {% set domain_name = 'drone.whyrl.fr' %}
          {%- load_yaml as locations %}
            location /:
              # - auth_basic: "Restricted"
              # - auth_basic_user_file: {{ defaults.authentication.file }}
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: Host $http_host
              - proxy_pass: http://127.0.0.1:8090
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}
