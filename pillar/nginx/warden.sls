#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}

nginx:
    install_from_repo: true
    service:
      enable: True
    servers:
      managed:
        bitwarden:
          enabled: True
          config:
            #
            # HTTP server on port 80, forward to 443 for postfixadmin
            - server:
              - server_name: warden.whyrl.fr
              - listen:
                - 80
                - '[::]:80'
              - root: /var/www/html
              - location ~ /\.well-known/acme-challenge:
                - allow:
                  - all
              - location /:
                - return:
                  - '301 https://$server_name$request_uri'
            #
            # HTTPS server on port 443 for rspamd
            - server:
              - server_name: warden.whyrl.fr
              - listen:
                - '443 ssl http2'
                - '[::]:443 ssl http2'
              - access_log: /var/log/nginx/warden.log
              - error_log: /var/log/nginx/warden.log
              - ssl_certificate: /etc/letsencrypt/live/warden.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/warden.whyrl.fr/privkey.pem
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
                - proxy_set_header: Host $host
                - proxy_redirect: 'off'
                - proxy_http_version: 1.1
                - proxy_pass: 'http://127.0.0.1:8080$1$is_args$args'
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
              - root: /var/www/html
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
              - access_log: /var/log/nginx/vault.log
              - error_log: /var/log/nginx/vault.log
              - ssl_certificate: /etc/letsencrypt/live/warden.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/warden.whyrl.fr/privkey.pem
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
                - proxy_set_header: Host $host
                - proxy_redirect: 'off'
                - proxy_http_version: 1.1
                - proxy_pass: 'http://127.0.0.1:8200$1$is_args$args'
                - proxy_intercept_errors: on
                - error_page 301 201 307 = \@handle_vault_standby
              - location \@handle_vault_standby:
                - set $saved_vault_endpoint '$upstream_http_location'
                - proxy_pass: $saved_vault_endpoint
