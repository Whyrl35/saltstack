#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}
{% from 'nginx/macros/server_definition.sls' import server_http_80,server_https_443 with context %}

include:
  - .common

nginx:
  servers:
    managed:
      postfixadmin:
        enabled: True
        config:
          {% set domain_name = 'postfixadmin.whyrl.fr' %}
          {%- load_yaml as options %}
            - root: /opt/postfixadmin/public
            - index: index.php
            - charset: {{ defaults.charset }}
            - ssl_session_cache: shared:SSL:10m
          {%- endload %}
          {%- load_yaml as locations %}
            location /:
              - try_files:
                - '$uri $uri/ index.php'
            location ~* \.php$:
              - fastcgi_split_path_info: ^(.+\.php)(/.+)$
              - include: fastcgi_params
              - fastcgi_pass: unix:/run/php/php-fpm.sock
              - fastcgi_index: index.php
              - include: fastcgi_params
              - fastcgi_param: SCRIPT_FILENAME $document_root$fastcgi_script_name
              - fastcgi_buffer_size: 16k
              - fastcgi_buffers: 4 16k
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations, options) | indent(11) }}

      rspamd:
        enabled: True
        config:
          {% set domain_name = 'rspamd.whyrl.fr' %}
          {%- load_yaml as locations %}
          location /:
            - proxy_set_header: 'Upgrade $http_upgrade'
            - proxy_set_header: 'Connection "upgrade"'
            - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
            - proxy_set_header: 'X-Forwarded-Proto $scheme'
            - proxy_set_header: 'Host $host'
            - proxy_redirect: "'off'"
            - proxy_http_version: 1.1
            - proxy_pass: http://127.0.0.1:11334
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      webmail:
        enabled: True
        config:
          {% set domain_name = 'webmail.whyrl.fr' %}
          {%- load_yaml as options %}
            - root: /opt/roundcubemail
            - index: index.php
            - charset: {{ defaults.charset }}
          {%- endload %}
          {%- load_yaml as locations %}
            location /:
              - try_files:
                - '$uri $uri/ index.php?$query_string'
            location ~* \.php$:
              - fastcgi_split_path_info: ^(.+\.php)(/.+)$
              - include: fastcgi_params
              - fastcgi_keep_conn: "'on'"
              - fastcgi_pass: unix:/run/php/php-fpm.sock
              - fastcgi_index: index.php
              - include: fastcgi_params
              - fastcgi_param: SCRIPT_FILENAME $document_root$fastcgi_script_name
              - fastcgi_buffer_size: 16k
              - fastcgi_buffers: 4 16k
            location ~ /\.ht:
              - deny: all
            location ~ install.php:
              - deny: all
            location ^~ /data:
              - deny: all
            location ^~ /installer:
              - deny: all
            location ^~ /temp:
              - deny: all
            location ^~ /config:
              - deny: all
            location ^~ /logs:
              - deny: all
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations, options) | indent(11) }}
