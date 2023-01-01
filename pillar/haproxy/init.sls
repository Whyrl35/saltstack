{% set secret = salt['vault'].read_secret('secret/salt/haproxy') %}
{% set websecret = salt['vault'].read_secret('secret/salt/web/nginx/user') %}
{% from 'haproxy/mail.jinja' import mail %}
{% from 'haproxy/saltmaster.jinja' import saltmaster %}
{% from 'haproxy/vault.jinja' import vault %}
{% from 'haproxy/webservers.jinja' import webservers %}
{% from 'haproxy/docker01.jinja' import docker01 %}

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
      httprequests: "use-service prometheus-exporter if { path /prom-metrics }"
      mode: http
      stats:
        enable: true
        uri: "/admin?stats"
        refresh: "20s"
        realm: LoadBalancer
        auth: "admin:{{ secret['admin'] }}"
    #TODO: here code specific listen !

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
        - backend-mail if host_postfixadmin
        - backend-mail if host_rspamd
        - backend-mail if host_webmail
        - backend-vault if host_saltgui
        - backend-vault if host_vault
        - backend-docker01 if host_grafana
        - backend-docker01 if host_warden
      default_backend: backend-vault

    webhooks:
      name: frontend-whyrl-webhooks
      bind:
        - "*:9000"
      mode: http
      acls:
        - http ssl_fc,not
        - host_salt hdr(host) -i salt.whyrl.fr
      reqadds:
        - "X-Forwarded-Protocol http if http"
      use_backends:
        - backend-webhook-salt if host_salt
      default_backend: backend-webhook-salt

    saltstack-publisher:
      name: frontend-saltstack-publisher
      bind:
        - "*:4505"
      mode: tcp
      default_backend: backend-saltstack-publisher-tcp

    saltstack-request:
      name: frontend-saltstack-request
      bind:
        - "*:4506"
      mode: tcp
      default_backend: backend-saltstack-request-tcp

  backends:
    per_ip_rates:
      sticktable: 'type ip size 1m expire 10m store http_req_rate(10s)'

#    whyrl:
#      name: backend-whyrl
#      mode: http
#      balance: roundrobin
#      options:
#        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ www.whyrl.fr'
#        - forwardfor
#      cookie: "SERVERUID insert indirect nocache"
#      extra:
#        - "http-response set-header X-Target %s"
#      servers:
#      { % for server, ips in webservers.items() % }
#        { { server.split('.')[0] } }:
#          host: { { ips[0] } }
#          port: 443
#          check: check check-ssl
#          extra: "ssl verify none cookie { { server.split('.')[0] } }"
#      { % endfor % }

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

    saltstack-webhook:
      name: backend-webhook-salt
      mode: http
      balance: source
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in saltmaster.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 9000
          check: check
      {% endfor %}

    saltstack-publisher-tcp:
      name: backend-saltstack-publisher-tcp
      mode: tcp
      balance: source
      servers:
      {% for server, ips in saltmaster.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 4505
      {% endfor %}

    saltstack-request-tcp:
      name: backend-saltstack-request-tcp
      mode: tcp
      balance: source
      servers:
      {% for server, ips in saltmaster.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 4506
      {% endfor %}
