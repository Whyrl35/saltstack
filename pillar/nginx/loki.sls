#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/web/nginx/user') %}
{% from 'nginx/common.jinja' import defaults %}

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
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: loki.whyrl.fr
            - listen:
              - 80
              - '[::]:80'
            - root: /usr/share/nginx/html
            - location ~ /\.well-known/acme-challenge:
              - auth_basic:
                - 'off'
              - allow:
                - all
            - location /:
              - return:
                - '301 https://$server_name$request_uri'

          #
          # HTTPS server on port 443 for rspamd
          - server:
            - server_name: loki.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/loki_access_log.json json_analytics
              - /var/log/nginx/loki_access.log
            - error_log: /var/log/nginx/loki_error.log
            - ssl_certificate: /etc/ssl/certs/whyrl.fr.fullchain.pem
            - ssl_certificate_key: /etc/ssl/private/whyrl.fr.key
            - ssl_session_timeout: {{ defaults.ssl.session_timeout }}
            - ssl_protocols: {{ defaults.ssl.protocol }}
            - ssl_prefer_server_ciphers: '{{ defaults.ssl.prefer_server_ciphers }}'
            - ssl_stapling: '{{ defaults.ssl.stapling }}'
            - ssl_stapling_verify: '{{ defaults.ssl.stapling_verify }}'
            {% for header in defaults.headers %}
            - add_header: {{ header }}
            {% endfor %}
            - location /robots.txt:
              - return: '200 "User-agent: *\Disallow: /\n"'
            - location /:
              - auth_basic: "Restricted"
              - auth_basic_user_file: {{ defaults.authentication.file }}
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: Host $http_host
              - proxy_pass: http://127.0.0.1:3100
