#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}

nginx:
    install_from_repo: true
    service:
      enable: True
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
              - server_name: grafana.whyrl.fr
              - listen:
                - '443 ssl http2'
                - '[::]:443 ssl http2'
              - access_log: /var/log/nginx/grafana-access.log
              - error_log: /var/log/nginx/grafana-error.log
              - ssl_certificate: /etc/letsencrypt/live/warp10.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/warp10.whyrl.fr/privkey.pem
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
                - proxy_pass: http://127.0.0.1:3000
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
              - server_name: warp10.whyrl.fr
              - listen:
                - '443 ssl http2'
                - '[::]:443 ssl http2'
              - access_log: /var/log/nginx/warp10-access.log
              - error_log: /var/log/nginx/warp10-error.log
              - ssl_certificate: /etc/letsencrypt/live/warp10.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/warp10.whyrl.fr/privkey.pem
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
