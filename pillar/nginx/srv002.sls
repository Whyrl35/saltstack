#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}

include:
  - .common

nginx:
  servers:
    managed:
      nas:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: nas.whyrl.fr
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
            - server_name: nas.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/nas_access_log.json json_analytics
              - /var/log/nginx/nas_access.log
            - error_log: /var/log/nginx/nas_error.log
            - ssl_certificate: /etc/letsencrypt/live/whyrl.fr/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/whyrl.fr/privkey.pem
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
              - proxy_pass: https://192.168.0.2:5001
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
            - location /photo/:
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: Host $http_host
              - proxy_pass: https://192.168.0.2/photo/
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme


      portainer:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: portainer.whyrl.fr
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
            - server_name: portainer.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/portainer_access_log.json json_analytics
              - /var/log/nginx/portainer_access.log
            - error_log: /var/log/nginx/portainer_error.log
            - ssl_certificate: /etc/letsencrypt/live/whyrl.fr/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/whyrl.fr/privkey.pem
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
              - proxy_set_header: Host $host
              - proxy_pass: http://127.0.0.1:9000
              - proxy_http_version: 1.1
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme


      hassio:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: hassio.whyrl.fr
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
            - server_name: hassio.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/hassio_access_log.json json_analytics
              - /var/log/nginx/hassio_access.log
            - error_log: /var/log/nginx/hassio_error.log
            - ssl_certificate: /etc/letsencrypt/live/whyrl.fr/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/whyrl.fr/privkey.pem
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
              - proxy_pass: http://127.0.0.1:8123
              - proxy_http_version: 1.1
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"
              - proxy_set_header: Host $host
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme
            - location /api/websocket:
              - proxy_pass: http://127.0.0.1:8123/api/websocket
              - proxy_http_version: 1.1
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"
              - proxy_set_header: Host $host
              - proxy_set_header: X-Real-IP $remote_addr
              - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
              - proxy_set_header: X-Forwarded-Proto $scheme

      homepanel:
        enabled: False
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: homepanel.whyrl.fr
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
            - server_name: homepanel.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/homepanel_access_log.json json_analytics
              - /var/log/nginx/homepanel_access.log
            - error_log: /var/log/nginx/homepanel_error.log
            - ssl_certificate: /etc/letsencrypt/live/whyrl.fr/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/whyrl.fr/privkey.pem
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
              - proxy_set_header: Host $host
              - proxy_pass: http://127.0.0.1:8234
              - proxy_http_version: 1.1
              - proxy_set_header: Upgrade $http_upgrade
              - proxy_set_header: Connection "upgrade"

      gateway:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: gateway.whyrl.fr
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
            - server_name: gateway.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/gateway_access_log.json json_analytics
              - /var/log/nginx/gateway_access.log
            - error_log: /var/log/nginx/gateway_error.log
            - ssl_certificate: /etc/letsencrypt/live/whyrl.fr/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/whyrl.fr/privkey.pem
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
              - proxy_pass: http://192.168.0.254

      extender:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: 'extend.whyrl.fr'
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
            - server_name: 'extend.whyrl.fr'
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/extend_access_log.json json_analytics
              - /var/log/nginx/extend_access.log
            - error_log: /var/log/nginx/extend_error.log
            - ssl_certificate: /etc/letsencrypt/live/whyrl.fr/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/whyrl.fr/privkey.pem
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
              - proxy_pass: http://192.168.0.253


      default:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: whyrl.fr www.whyrl.fr
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
          # HTTPS server on port 443 for postfixadmin
          - server:
            - server_name: whyrl.fr www.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/default_access_log.json json_analytics
              - /var/log/nginx/default_access.log
            - error_log: /var/log/nginx/default_error.log
            - root: /var/www/website/
            - index: index.html index.htm
            - charset: {{ defaults.charset }}
            - ssl_certificate: /etc/letsencrypt/live/whyrl.fr/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/whyrl.fr/privkey.pem
            - ssl_session_cache: shared:SSL:10m
            - ssl_session_timeout: {{ defaults.ssl.session_timeout }}
            - ssl_protocols: {{ defaults.ssl.protocol }}
            - ssl_prefer_server_ciphers: '{{ defaults.ssl.prefer_server_ciphers }}'
            - ssl_stapling: '{{ defaults.ssl.stapling }}'
            - ssl_stapling_verify: '{{ defaults.ssl.stapling_verify }}'
            {% for header in defaults.headers %}
            - add_header: {{ header }}
            {% endfor %}
            - location /:
              - try_files:
                - '$uri /index.html'
