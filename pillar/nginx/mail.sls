#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}

include:
  - .common

nginx:
  servers:
    managed:
      postfixadmin:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: postfixadmin.whyrl.fr
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
            - server_name: postfixadmin.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/postfixadmin_access_log.json json_analytics
              - /var/log/nginx/postfixadmin_access.log
            - error_log: /var/log/nginx/postfixadmin_error.log
            - root: /usr/share/postfixadmin/public
            - index: index.php
            - charset: {{ defaults.charset }}
            - ssl_certificate: /etc/ssl/certs/whyrl.fr.fullchain.pem
            - ssl_certificate_key: /etc/ssl/private/whyrl.fr.key
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
                - '$uri $uri/ index.php'
            - location ~* \.php$:
              - fastcgi_split_path_info: ^(.+\.php)(/.+)$
              - include: fastcgi_params
              - fastcgi_pass: unix:/run/php/php-fpm.sock
              - fastcgi_index: index.php
              - include: fastcgi_params
              - fastcgi_param: SCRIPT_FILENAME $document_root$fastcgi_script_name
              - fastcgi_buffer_size: 16k
              - fastcgi_buffers: 4 16k

      rspamd:
        enabled: True
        config:
          #
          # HTTPS server on port 443 for rspamd
          - server:
            - server_name: rspamd.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/rspamd_access_log.json json_analytics
              - /var/log/nginx/rspamd_access.log
            - error_log: /var/log/nginx/rspamd-error.log
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
              - proxy_pass: http://127.0.0.1:11334

      webmail:
        enabled: True
        config:
          #
          # HTTP server on port 80, forward to 443 for postfixadmin
          - server:
            - server_name: webmail.whyrl.fr
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
            - server_name: webmail.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - access_log:
              - /var/log/nginx/webmail_access_log.json json_analytics
              - /var/log/nginx/webmail_access.log
            - error_log: /var/log/nginx/wemaili_error.log
            - root: /var/www/rainloop
            - index: index.php
            - charset: {{ defaults.charset }}
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
            - location /:
              - try_files:
                - '$uri $uri/ index.php?$query_string'
            - location ~* \.php$:
              - fastcgi_split_path_info: ^(.+\.php)(/.+)$
              - include: fastcgi_params
              - fastcgi_keep_conn: 'on'
              - fastcgi_pass: unix:/run/php/php-fpm.sock
              - fastcgi_index: index.php
              - include: fastcgi_params
              - fastcgi_param: SCRIPT_FILENAME $document_root$fastcgi_script_name
              - fastcgi_buffer_size: 16k
              - fastcgi_buffers: 4 16k
            - location ~ /\.ht:
              - deny: all
            - location ~ install.php:
              - deny: all
            - location ^~ /data:
              - deny: all
