#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}

include:
  - .common

nginx:
  servers:
    managed:
      whyrl:
        enabled: True
        config:
          - server:
            - server_name: www.whyrl.fr
            - listen:
              - 80
              - '[::]:80'
            - root: /srv/web/www
            - location ~ /\.well-known/acme-challenge:
              - allow:
                - all
            - location /:
              - return:
                - '301 https://$server_name$request_uri'
          #
          # HTTPS server on port 443 for postfixadmin
          - server:
            - server_name: www.whyrl.fr
            - listen:
              - '443 ssl http2'
              - '[::]:443 ssl http2'
            - include: snippets/self-signed.conf
            - include: snippets/ssl-params.conf
            - access_log:
              - /var/log/nginx/whyrl_access_log.json json_analytics
              - /var/log/nginx/whyrl_access.log
            - error_log: /var/log/nginx/whyrl_error.log
            - root: /srv/web/www
            - index: index.html index.htm
            - charset: {{ defaults.charset }}
            {% for header in defaults.headers %}
            - add_header: {{ header }}
            {% endfor %}
            - location /:
              - try_files:
                - '$uri /index.html'
