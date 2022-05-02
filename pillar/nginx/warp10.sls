#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}
{% set https_ready = True %}

include:
  - .common

nginx:
  servers:
    managed:
      grafana:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: grafana.whyrl.fr
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
          {% if https_ready %}
          - server:
            - server_name: grafana.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/grafana_access_log.json json_analytics
              - /var/log/nginx/grafana_access.log
            - error_log: /var/log/nginx/grafana_error.log
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
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: Host $http_host
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_pass: http://127.0.0.1:3000
            - location /api/live/ws:
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: Host $http_host
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "Upgrade"
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_redirect: 'off'
              - proxy_http_version: 1.1
              - proxy_pass: http://127.0.0.1:3000
          {% endif %}
      warp10:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: warp10.whyrl.fr
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
          {% if https_ready %}
          - server:
            - client_max_body_size: 4G
            - server_name: warp10.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/warp10_access_log.json json_analytics
              - /var/log/nginx/warp10_access.log
            - error_log: /var/log/nginx/warp10_error.log
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
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: Host $http_host
              - proxy_pass: http://127.0.0.1:8080
          {% endif %}
