nginx:
  ng:
    install_from_repo: false
    service:
      enable: True

    ################################# MAIL SERVER ###############################

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
              - access_log: /var/log/nginx/postfixadmin-access.log
              - error_log: /var/log/nginx/postfixadmin-error.log
              - root: /usr/share/postfixadmin
              - index: index.php
              - charset: utf-8
              # TODO SEE documentation here to continue : https://www.rosehosting.com/blog/setup-and-configure-a-mail-server-with-postfixadmin/
              # - then make the state to change the php file and continue : https://blog.tetsumaki.net/articles/2017/08/installation-dune-solution-mail-complete-sous-debian-9-stretch.html#anchor7
              - ssl_certificate: /etc/letsencrypt/live/postfixadmin.whyrl.fr/fullchain.pem
              - ssl_certificate_key: /etc/letsencrypt/live/postfixadmin.whyrl.fr/privkey.pem
              - ssl_protocols: TLSv1.2
              - ssl_ciphers: "EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS:!RC4"
              - ssl_prefer_server_ciphers: "on"
              - ssl_session_cache: shared:SSL:10m
              - ssl_session_timeout: 10m
              - ssl_ecdh_curve: secp521r1
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
              - ssl_protocols: TLSv1.2
              - ssl_ecdh_curve: X25519:sect571r1:secp521r1:secp384r1
              - ssl_ciphers: "ECDHE-RSA-CHACHA20-POLY1305:EECDH+AES:+AES128:+AES256:+SHA"
              - ssl_prefer_server_ciphers: "on"
              - ssl_session_timeout: 1d
              - ssl_session_tickets: 'off'
              - ssl_stapling: 'on'
              - ssl_stapling_verify: 'on'
              - add_header: Strict-Transport-Security "max-age=15552000; includeSubDomains; preload"
              - add_header: X-Content-Type-Options nosniff
              - add_header: X-Frame-Options SAMEORIGIN
              - add_header: X-XSS-Protection "1; mode=block"
              - location /robots.txt:
                - return: '200 "User-agent: *\Disallow: /\n"'
              - location /:
                - proxy_set_header: X-Forwarded-For $proxy_add_x_forwarded_for
                - proxy_set_header: Host $http_host
                - proxy_pass: http://127.0.0.1:11334

    {% endif %}
