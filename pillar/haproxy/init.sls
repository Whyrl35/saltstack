{% set secret = salt['vault'].read_secret('secret/salt/haproxy') %}
{% set websecret = salt['vault'].read_secret('secret/salt/web/nginx/user') %}
{% from 'haproxy/mail.jinja' import mail %}
{% from 'haproxy/saltmaster.jinja' import saltmaster %}
{% from 'haproxy/vault.jinja' import vault %}
{% from 'haproxy/webservers.jinja' import webservers %}
{% from 'haproxy/docker01.jinja' import docker01 %}
{% from 'haproxy/loki.jinja' import loki %}

haproxy:
  global:
    stats:
      enable: true
      socketpath: /run/haproxy/stats.sock
      mode: 660
      level: admin
      extra: user haproxy group haproxy
    ssl-default-bind-ciphersuites: TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
    ssl-default-bind-options: prefer-client-ciphers no-sslv3 no-tlsv10 no-tlsv11 no-tls-tickets no-tlsv12
    ssl-default-server-ciphersuites: TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
    ssl-default-server-options: no-sslv3 no-tlsv10 no-tlsv11 no-tls-tickets #no-tlsv12
  defaults:
    timeouts:
      - http-request    10s
      - queue           1m
      - connect         10s
      - client          1m
      - server          1m
      - http-keep-alive 10s
      - check           10s
    options:
      - httplog
      - dontlognull
      - forwardfor
      - http-server-close
      - http-buffer-request
  listens:
    stats:
      bind:
        - "0.0.0.0:8801 ssl crt /etc/letsencrypt/live/whyrl.fr/fullcertandkey.pem alpn h2,http/1.1"
      httprequests: "use-service prometheus-exporter if { path /metrics }"
      mode: http
      stats:
        enable: true
        uri: "/admin?stats"
        refresh: "20s"
        realm: LoadBalancer
        auth: "admin:{{ secret['admin'] }}"

  frontends:
    whyrl:
      name: frontend-whyrl
      bind:
        - "*:80"
        - "*:443 ssl crt /etc/letsencrypt/live/whyrl.fr/fullcertandkey.pem alpn h2,http/1.1"
      mode: http
      options:
        - forwardfor
      redirects:
        - scheme https code 301 if !{ ssl_fc }
      acls:
        - http ssl_fc,not
        - https ssl_fc
        - host_grafana hdr(host) -i grafana.whyrl.fr
        - host_postfixadmin hdr(host) -i postfixadmin.whyrl.fr
        - host_rspamd hdr(host) -i rspamd.whyrl.fr
        - host_saltgui hdr(host) -i saltgui.whyrl.fr
        - host_vault hdr(host) -i vault.whyrl.fr
        - host_warden hdr(host) -i warden.whyrl.fr
        - host_webmail hdr(host) -i webmail.whyrl.fr
        - host_loki hdr(host) -i loki.whyrl.fr
        - host_blog hdr(host) -i blog.whyrl.fr
        - host_www hdr(host) -i www.whyrl.fr
      httprequests:
        - 'track-sc0 src table per_ip_rates'
        - 'deny deny_status 429 if { sc_http_req_rate(0) gt 300 }'
        # If User-Agent is in the list, deny
        - 'deny if { req.hdr(user-agent) -i -m sub majestic }'
        - 'deny unless { req.hdr(user-agent) -m found }'
      reqadds:
        - "X-Forwarded-Protocol http if http"
        - "X-Forwarded-Protocol https if https"
      extra:
        - "http-response set-header Strict-Transport-Security max-age=63072000"
      use_backends:
        - backend-loki if host_loki
        - backend-mail if host_postfixadmin
        - backend-mail if host_rspamd
        - backend-mail if host_webmail
        - backend-vault if host_saltgui
        - backend-vault if host_vault
        - backend-docker01 if host_grafana
        - backend-docker01 if host_warden
        - backend-whyrl if host_blog
        - backend-whyrl if host_www
      default_backend: backend-whyrl

  backends:
    per_ip_rates:
      sticktable: 'type ip size 1m expire 10m store http_req_rate(10s)'

    whyrl:
      name: backend-whyrl
      mode: http
      balance: roundrobin
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ blog.whyrl.fr'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in webservers.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    loki:
      name: backend-loki
      mode: http
      balance: source
      # httpcheck: expect status 401
      options:
        # - 'httpchk HEAD / HTTP/1.1\r\nHost:\ loki.whyrl.fr'
        - 'httpchk GET /loki/api/v1/status/buildinfo HTTP/1.1\r\nHost:\ loki.whyrl.fr\r\nAuthorization:\ Basic\ {{ ('loki:' ~ websecret["loki"]) | base64_encode }}'  # noqa: 204
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in loki.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    mail:
      name: backend-mail
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ postfixadmin.whyrl.fr'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in mail.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    docker01:
      name: backend-docker01
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ warden.whyrl.fr'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in docker01.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    vault:
      name: backend-vault
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ vault.whyrl.fr'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in vault.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}
