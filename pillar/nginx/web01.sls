#!jinja|yaml|gpg

{% from 'nginx/common.jinja' import defaults %}
{% from 'nginx/macros/server_definition.sls' import server_http_80,server_https_443 with context %}
{% set secret = salt['vault'].read_secret('secret/salt/web/nginx/user') %}

include:
  - .common

nginx:
  servers:
    managed:
      blokg:
        enabled: True
        config:
          {% set domain_name = 'blog.whyrl.fr' %}
          {%- load_yaml as locations %}
          location /:
            - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
            - proxy_set_header: X-Forwarded-Proto $scheme
            - proxy_set_header: X-Real-IP $remote_addr
            - real_ip_header: X-Forwarded-For
            - proxy_set_header: Host $http_host
            - proxy_pass: http://127.0.0.1:2368
            # Security
            - proxy_hide_header: X-Powered-By
            - add_header: X-Frame-Options SAMEORIGIN
            - add_header: X-Content-Type-Options nosniff
            - add_header: Referrer-Policy 'strict-origin-when-cross-origin'
            - add_header: Permissions-Policy "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()"  # noqa: 204
            - add_header: Content-Security-Policy "default-src 'self'; base-uri 'self'; font-src 'self' https://fonts.gstatic.com/; style-src 'self' https://c.disquscdn.com/ https://fonts.googleapis.com/ https://cdnjs.cloudflare.com/ 'unsafe-inline'; script-src-elem 'self' https://blog-whyrl.disqus.com/ https://cdn.taboola.com/ https://c.disquscdn.com/ https://disqus.com/ https://referrer.disqus.com/ https://tempest.services.disqus.com/ https://unpkg.com/ https://www.googletagmanager.com/ https://cdnjs.cloudflare.com/ https://code.jquery.com https://tenor.com/ 'unsafe-inline'; img-src 'self' https://cdn.viglink.com/ https://*.disqus.com/ https://c.disquscdn.com/ http://blog.whyrl.fr/ https://www.gravatar.com/ https://tenor.com/ data:; connect-src 'self' http://blog.whyrl.fr/ https://links.services.disqus.com/ https://tempest.services.disqus.com https://www.google-analytics.com/; frame-src 'self' https://giphy.com/ https://tenor.com/ https://disqus.com/; prefetch-src 'self' https://c.disquscdn.com/ https://disqus.com/ https://tempest.services.disqus.com/ "  # noqa: 204
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      www:
        enabled: True
        config:
          {% set domain_name = 'www.whyrl.fr' %}
          {%- load_yaml as locations %}
          location /:
            - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
            - proxy_set_header: X-Forwarded-Proto $scheme
            - proxy_set_header: X-Real-IP $remote_addr
            - proxy_set_header: Host $http_host
            # Security
            - proxy_hide_header: X-Powered-By
            - add_header: X-Frame-Options SAMEORIGIN
            - add_header: X-Content-Type-Options nosniff
            - add_header: Referrer-Policy 'strict-origin-when-cross-origin'
            - add_header: Permissions-Policy "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()"  # noqa: 204
            - add_header: Content-Security-Policy "default-src 'self'; base-uri 'self'; font-src 'self' https://fonts.gstatic.com/; style-src 'self' https://c.disquscdn.com/ https://fonts.googleapis.com/ https://cdnjs.cloudflare.com/ 'unsafe-inline'; script-src-elem 'self' https://blog-whyrl.disqus.com/ https://cdn.taboola.com/ https://c.disquscdn.com/ https://disqus.com/ https://referrer.disqus.com/ https://tempest.services.disqus.com/ https://unpkg.com/ https://www.googletagmanager.com/ https://cdnjs.cloudflare.com/ https://code.jquery.com https://tenor.com/ 'unsafe-inline'; img-src 'self' https://cdn.viglink.com/ https://*.disqus.com/ https://c.disquscdn.com/ http://blog.whyrl.fr/ https://www.gravatar.com/ https://tenor.com/ data:; connect-src 'self' http://blog.whyrl.fr/ https://links.services.disqus.com/ https://tempest.services.disqus.com https://www.google-analytics.com/; frame-src 'self' https://giphy.com/ https://tenor.com/ https://disqus.com/; prefetch-src 'self' https://c.disquscdn.com/ https://disqus.com/ https://tempest.services.disqus.com/ "  # noqa: 204
            - root: /srv/www/website
            - index: index.html index.htm
            - charset: utf-8
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations) | indent(11) }}

      nadine:
        enabled: True
        config:
          {% set domain_name = 'madame-de-compagnie.fr' %}
          {%- load_yaml as options %}
            - root: /srv/www/nadine
            - index: index.html index.htm index.php
            - charset: {{ defaults.charset }}
            - ssl_session_cache: shared:SSL:10m
          {%- endload %}
          {%- load_yaml as locations %}
          location /:
            - try_files: $uri $uri/ =404
          location ~ \.php$:
            - try_files: $uri =404
            - include: fastcgi_params
            - fastcgi_index: index.php
            - fastcgi_param: SCRIPT_FILENAME $document_root$fastcgi_script_name
            - fastcgi_pass: unix:/var/run/php/php8.2-fpm.sock
          location ~ /\.ht:
            - deny: all
          {%- endload %}

          # HTTP server on port 80, forward to 443 for postfixadmin
          - {{ server_http_80(domain_name) | indent(11) }}
          # HTTPS server on port 443 for rspamd
          - {{ server_https_443(domain_name, locations, options, www=True) | indent(11) }}
