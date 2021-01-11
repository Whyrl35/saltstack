#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}

nginx:
    install_from_repo: true
    service:
      enable: True
    servers:
      managed:
        default:
          enabled: True
          config:
            #
            # HTTP server on port 80, forward to 443 for postfixadmin
            - server:
              - server_name: ks.whyrl.fr www.ks.whyrl.fr
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
            # HTTPS server on port 443 for postfixadmin
            - server:
              - server_name: ks.whyrl.fr www.ks.whyrl.fr
              - listen:
                - '443 ssl http2'
                - '[::]:443 ssl http2'
              - access_log: /var/log/nginx/default-access.log
              - error_log: /var/log/nginx/default-error.log
              - root: /var/www/website/
              - index: index.html index.htm
              - charset: {{ defaults.charset }}
              - ssl_certificate: /etc/letsencrypt/live/ks.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/ks.whyrl.fr/privkey.pem
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

