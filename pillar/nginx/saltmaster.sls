#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}
include:
  - .common

nginx:
  servers:
    managed:
      saltpad:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: saltpad.whyrl.fr
            - listen:
              - '80 default_server'
              - '[::]:80 default_server ipv6only=on'
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
            - server_name: salt.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log: /var/log/nginx/saltpad-access.log
            - error_log: /var/log/nginx/saltpad-error.log
            - ssl_certificate: /etc/letsencrypt/live/saltpad.whyrl.fr/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/saltpad.whyrl.fr/privkey.pem
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
            - root: /opt/alcali
            - location /:
              - proxy_set_header: 'X-Real-IP $remote_addr'
              - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
              - proxy_set_header: 'X-NginX-Proxy true'
              - proxy_pass: 'http://127.0.0.1:8000/'
              - proxy_ssl_session_reuse: 'off'
              - proxy_set_header: 'Host $http_host'
              - proxy_redirect: 'off'
