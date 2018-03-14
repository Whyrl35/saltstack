############################## Default configuration ############################
#
{%- load_yaml as defaults %}
charset: utf-8
ssl:
  protocol: TLSv1.2
  ecdh_curve: "prime256v1:secp384r1:secp521r1"
  ciphers: "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256"
  prefer_server_ciphers: 'on'
  session_timeout: 1d
  session_ticket: 'off'
  stapling: 'on'
  stapling_verify: 'on'
headers:
  - Strict-Transport-Security "max-age=15768000; includeSubDomains; preload"
  - X-Content-Type-Options nosniff
  - X-Frame-Options SAMEORIGIN
  - X-XSS-Protection "1; mode=block"
{%- endload %}


################################ NGINX configuration ############################
#
nginx:
  ng:
    install_from_repo: false
    service:
      enable: True
################################# MAIL SERVER ###################################
#
{% if 'mail_server' in grains['roles'] %}
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
              - return:
                - 301
                - https://$server_name$request_uri
            #
            # HTTPS server on port 443 for postfixadmin
            - server:
              - server_name: postfixadmin.whyrl.fr
              - listen:
                - 443
                - ssl
                - http2
              - access_log: /var/log/nginx/postfixadmin-access.log
              - error_log: /var/log/nginx/postfixadmin-error.log
              - root: /usr/share/postfixadmin
              - index: index.php
              - charset: {{ defaults.charset }}
              - ssl_certificate: /etc/letsencrypt/live/postfixadmin.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/postfixadmin.whyrl.fr/privkey.pem
              - ssl_session_cache: shared:SSL:10m
              - ssl_session_timeout: {{ defaults.ssl.session_timeout }}
              - ssl_protocols: {{ defaults.ssl.protocol }}
              - ssl_ecdh_curve: {{ defaults.ssl.ecdh_curve }}
              - ssl_ciphers: '{{ defaults.ssl.ciphers }}'
              - ssl_prefer_server_ciphers: '{{ defaults.ssl.prefer_server_ciphers }}'
              - ssl_session_tickets: '{{ defaults.ssl.session_ticket }}'
              - ssl_stapling: '{{ defaults.ssl.stapling }}'
              - ssl_stapling_verify: '{{ defaults.ssl.stapling_verify }}'
              {% for header in defaults.headers %}
              - add_header: {{ header }}
              {% endfor %}
              - location /:
                - try_files:
                  - $uri
                  - $uri/
                  - index.php
              - location ~* \.php$:
                - fastcgi_split_path_info: ^(.+\.php)(/.+)$
                - include: fastcgi_params
                - fastcgi_pass: unix:/run/php/php7.0-fpm.sock
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
                - 443
                - ssl
                - http2
              - access_log: /var/log/nginx/rspamd-access.log
              - error_log: /var/log/nginx/rspamd-error.log
              - ssl_certificate: /etc/letsencrypt/live/postfixadmin.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/postfixadmin.whyrl.fr/privkey.pem
              - ssl_session_timeout: {{ defaults.ssl.session_timeout }}
              - ssl_protocols: {{ defaults.ssl.protocol }}
              - ssl_ecdh_curve: {{ defaults.ssl.ecdh_curve }}
              - ssl_ciphers: '{{ defaults.ssl.ciphers }}'
              - ssl_prefer_server_ciphers: '{{ defaults.ssl.prefer_server_ciphers }}'
              - ssl_session_tickets: '{{ defaults.ssl.session_ticket }}'
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
              - return:
                - 301
                - https://$server_name$request_uri
            #
            # HTTPS server on port 443 for postfixadmin
            - server:
              - server_name: webmail.whyrl.fr
              - listen:
                - 443
                - ssl
                - http2
              - access_log: /var/log/nginx/webmail-access.log
              - error_log: /var/log/nginx/wemail-error.log
              - root: /var/www/rainloop
              - index: index.php
              - charset: {{ defaults.charset }}
              - ssl_certificate: /etc/letsencrypt/live/postfixadmin.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/postfixadmin.whyrl.fr/privkey.pem
              - ssl_session_timeout: {{ defaults.ssl.session_timeout }}
              - ssl_protocols: {{ defaults.ssl.protocol }}
              - ssl_ecdh_curve: {{ defaults.ssl.ecdh_curve }}
              - ssl_ciphers: '{{ defaults.ssl.ciphers }}'
              - ssl_prefer_server_ciphers: '{{ defaults.ssl.prefer_server_ciphers }}'
              - ssl_session_tickets: '{{ defaults.ssl.session_ticket }}'
              - ssl_stapling: '{{ defaults.ssl.stapling }}'
              - ssl_stapling_verify: '{{ defaults.ssl.stapling_verify }}'
              {% for header in defaults.headers %}
              - add_header: {{ header }}
              {% endfor %}
              - location /:
                - try_files:
                  - $uri
                  - $uri/
                  - index.php?$query_string
              - location ~* \.php$:
                - fastcgi_split_path_info: ^(.+\.php)(/.+)$
                - include: fastcgi_params
                - fastcgi_keep_conn: 'on'
                - fastcgi_pass: unix:/run/php/php7.0-fpm.sock
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
{% endif %}


################################ WAZUH SERVER ###################################
#
{% if 'wazuh_server' in grains['roles'] %}
    servers:
      managed:
        wazuh:
          enabled: True
          config:
            #
            # HTTP server on port 80, forward to 443 for postfixadmin
            - server:
              - server_name: wazuh.whyrl.fr
              - listen:
                - 80
              - return:
                - 301
                - https://$server_name$request_uri
            #
            # HTTPS server on port 443 for rspamd
            - server:
              - server_name: wazuh.whyrl.fr
              - listen:
                - 443
                - ssl
                - http2
              - access_log: /var/log/nginx/wazuh-access.log
              - error_log: /var/log/nginx/wazuh-error.log
              - ssl_certificate: /etc/letsencrypt/live/wazuh.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/wazuh.whyrl.fr/privkey.pem
              - ssl_session_timeout: {{ defaults.ssl.session_timeout }}
              - ssl_protocols: {{ defaults.ssl.protocol }}
              - ssl_ecdh_curve: {{ defaults.ssl.ecdh_curve }}
              - ssl_ciphers: '{{ defaults.ssl.ciphers }}'
              - ssl_prefer_server_ciphers: '{{ defaults.ssl.prefer_server_ciphers }}'
              - ssl_session_tickets: '{{ defaults.ssl.session_ticket }}'
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
                - proxy_pass: http://127.0.0.1:5601
        wigo:
          enabled: True
          config:
            #
            # HTTP server on port 80, forward to 443 for postfixadmin
            - server:
              - server_name: wigo.whyrl.fr
              - listen:
                - 80
              - return:
                - 301
                - https://$server_name$request_uri
            #
            # HTTPS server on port 443 for rspamd
            - server:
              - server_name: wigo.whyrl.fr
              - listen:
                - 443
                - ssl
                - http2
              - access_log: /var/log/nginx/wigo-access.log
              - error_log: /var/log/nginx/wigo-error.log
              - ssl_certificate: /etc/letsencrypt/live/wigo.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/wigo.whyrl.fr/privkey.pem
              - ssl_session_timeout: {{ defaults.ssl.session_timeout }}
              - ssl_protocols: {{ defaults.ssl.protocol }}
              - ssl_ecdh_curve: {{ defaults.ssl.ecdh_curve }}
              - ssl_ciphers: '{{ defaults.ssl.ciphers }}'
              - ssl_prefer_server_ciphers: '{{ defaults.ssl.prefer_server_ciphers }}'
              - ssl_session_tickets: '{{ defaults.ssl.session_ticket }}'
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
                - proxy_pass: http://127.0.0.1:4000

{% endif %}