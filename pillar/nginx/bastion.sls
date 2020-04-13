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
              - server_name: bastion.whyrl.fr
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
              - server_name: bastion.whyrl.fr
              - listen:
                - '443 ssl http2'
                - '[::]:443 ssl http2'
              - access_log: /var/log/nginx/bastion.log
              - error_log: /var/log/nginx/bastion.log
              - ssl_certificate: /etc/letsencrypt/live/bastion.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/bastion.whyrl.fr/privkey.pem
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
                - try_files:
                  - '$uri $uri/ /index.html'
              - location /static/:
                - root:
                  - /var/www/sshportal
              - location ~ ^/api(.*)$:
                - proxy_set_header: Upgrade $http_upgrade
                - proxy_set_header: Connection "upgrade"
                - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
                - proxy_set_header: X-Forwarded-Proto $scheme
                - proxy_set_header: Host $host_host
                - proxy_redirect: 'off'
                - proxy_http_version: 1.1
                - proxy_pass: 'http://127.0.0.1:8000$1$is_args$args'
