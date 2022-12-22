#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}

include:
  - .common

nginx:
  servers:
    managed:
      vault:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: vault.whyrl.fr
            - listen:
              - 80
              - '[::]:80'
            - root: /usr/share/nginx/html
            - location ~ /\.well-known/acme-challenge:
              - allow:
                - all
            - location /:
              - return:
                - '301 https://$server_name$request_uri'
          #
          # HTTPS server on port 443 for rspamd
          - server:
            - server_name: vault.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/vault_access_log.json json_analytics
              - /var/log/nginx/vault_access.log
            - error_log: /var/log/nginx/vault_error.log
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
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: Host $host
              - proxy_redirect: 'off'
              - proxy_http_version: 1.1
              - proxy_pass: 'https://vault.cloud.whyrl.fr:8200'

      saltgui:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: saltgui.whyrl.fr
            - listen:
              - 80
              - '[::]:80'
            - root: /usr/share/nginx/html
            - location ~ /\.well-known/acme-challenge:
              - allow:
                - all
            - location /:
              - return:
                - '301 https://$server_name$request_uri'
          #
          # HTTPS server on port 443 for rspamd
          - server:
            - server_name: saltgui.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/saltgui_access_log.json json_analytics
              - /var/log/nginx/saltgui_access.log
            - error_log: /var/log/nginx/saltgui_error.log
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
            - root: '/opt/SaltGUI/saltgui'
            - location /robots.txt:
              - return: '200 "User-agent: *\Disallow: /\n"'
            - location /api/:
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_ssl_session_reuse: 'off'
              - proxy_set_header: Host $http_host
              - proxy_redirect: 'off'
              - proxy_pass: 'http://127.0.0.1:3333/'
            - location /:
              - try_files:
                - '$uri /index.html'
