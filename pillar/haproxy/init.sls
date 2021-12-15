{% set secret = salt['vault'].read_secret('secret/salt/haproxy') %}
{% from 'haproxy/webservers.jinja' import webservers %}
{% from 'haproxy/warden.jinja' import warden %}

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
      mode: http
      stats:
        enable: true
        uri: "/admin?stats"
        refresh: "20s"
        realm: LoadBalancer
        auth: "admin:{{ secret['admin']}}"
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
        - host_blog hdr(host) -i blog.whyrl.fr
        - host_warden hdr(host) -i warden.whyrl.fr
      httprequests:
        - 'track-sc0 src table per_ip_rates'
        - 'deny deny_status 429 if { sc_http_req_rate(0) gt 100 }'
        # If User-Agent is in the list, deny
        - 'deny if { req.hdr(user-agent) -i -m sub majestic }'
        - 'deny unless { req.hdr(user-agent) -m found }'
      reqadds:
        - "X-Forwarded-Protocol http if http"
        - "X-Forwarded-Protocol https if https"
      extra: "http-response set-header Strict-Transport-Security max-age=63072000"
      use_backends:
        - backend-blog if host_blog
        - backend-warden if host_warden
      default_backend: backend-whyrl

  backends:
    per_ip_rates:
      sticktable: 'type ip size 1m expire 10m store http_req_rate(10s)'

    whyrl:
      name: backend-whyrl
      mode: http
      balance: roundrobin
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ www.whyrl.fr'
      cookie: "SERVERUID insert indirect nocache"
      httprequests:
        - "set-header X-Target  %[req.hdr(Host)]"
      servers:
      {% for server, ips in webservers.items() %}
        {{ server }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    blog:
      name: backend-blog
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ blog.whyrl.fr'
      cookie: "SERVERUID insert indirect nocache"
      httprequests:
        - "set-header X-Target  %[req.hdr(Host)]"
      servers:
      {% for server, ips in webservers.items() %}
        {{ server }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    warden:
      name: backend-warden
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ warden.whyrl.fr'
      cookie: "SERVERUID insert indirect nocache"
      httprequests:
        - "set-header X-Target  %[req.hdr(Host)]"
      servers:
      {% for server, ips in warden.items() %}
        {{ server }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}
