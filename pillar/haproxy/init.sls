{% set secret = salt['vault'].read_secret('secret/salt/haproxy') %}
{% from 'haproxy/bastion.jinja' import bastion %}
{% from 'haproxy/loki.jinja' import loki %}
{% from 'haproxy/mail.jinja' import mail %}
{% from 'haproxy/nexus.jinja' import nexus %}
{% from 'haproxy/saltmaster.jinja' import saltmaster %}
{% from 'haproxy/vault.jinja' import vault %}
{% from 'haproxy/warden.jinja' import warden %}
{% from 'haproxy/warp10.jinja' import warp10 %}
{% from 'haproxy/wazuh.jinja' import wazuh %}
{% from 'haproxy/webservers.jinja' import webservers %}
{% from 'haproxy/wigo.jinja' import wigo %}

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
        - host_bastion hdr(host) -i sshportal.whyrl.fr
        - host_blog hdr(host) -i blog.whyrl.fr
        - host_grafana hdr(host) -i grafana.whyrl.fr
        - host_loki hdr(host) -i loki.whyrl.fr
        - host_nexus hdr(host) -i nexus.whyrl.fr
        - host_mail hdr(host) -i webmail.whyrl.fr
        - host_mail hdr(host) -i rspamd.whyrl.fr
        - host_mail hdr(host) -i postfixadmin.whyrl.fr
        - host_salt hdr(host) -i saltui.whyrl.fr
        - host_vault hdr(host) -i vault.whyrl.fr
        - host_warp10 hdr(host) -i warp10.whyrl.fr
        - host_warden hdr(host) -i warden.whyrl.fr
        - host_wazuh hdr(host) -i wazuh.whyrl.fr
        - host_wigo hdr(host) -i wigo.whyrl.fr
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
        - backend-bastion if host_bastion
        - backend-blog if host_blog
        - backend-loki if host_loki
        - backend-mail if host_mail
        - backend-nexus if host_nexus
        - backend-salt if host_salt
        - backend-vault if host_vault
        - backend-warden if host_warden
        - backend-warp10 if host_grafana
        - backend-warp10 if host_warp10
        - backend-wazuh if host_wazuh
        - backend-wigo if host_wigo
      default_backend: backend-whyrl

    wigo:
      name: frontend-wigo
      bind:
        - "*:4001"
      mode: tcp
      default_backend: backend-wigo-tcp

  backends:
    per_ip_rates:
      sticktable: 'type ip size 1m expire 10m store http_req_rate(10s)'

    whyrl:
      name: backend-whyrl
      mode: http
      balance: roundrobin
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ www.whyrl.fr'
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

    bastion:
      name: backend-bastion
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ bastion.whyrl.fr'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in bastion.items() %}
        {{ server.split('.')[0] }}:
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
      httpcheck: expect status 401
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ loki.whyrl.fr'
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
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ webmail.whyrl.fr'
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

    nexus:
      name: backend-nexus
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ nexus.whyrl.fr'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in nexus.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    salt:
      name: backend-salt
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ saltui.whyrl.fr'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in saltmaster.items() %}
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

    warden:
      name: backend-warden
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ warden.whyrl.fr'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in warden.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    warp10:
      name: backend-warp10
      mode: http
      balance: source
      options:
        - 'httpchk'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in warp10.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    wazuh:
      name: backend-wazuh
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ wazuh.whyrl.fr'
        - forwardfor
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in wazuh.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    wigo:
      name: backend-wigo
      mode: http
      balance: source
      options:
        - 'httpchk HEAD / HTTP/1.1\r\nHost:\ wigo.whyrl.fr'
        - forwardfor
      httpcheck: expect status 401
      cookie: "SERVERUID insert indirect nocache"
      extra:
        - "http-response set-header X-Target %s"
      servers:
      {% for server, ips in wigo.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 443
          check: check check-ssl
          extra: "ssl verify none cookie {{ server.split('.')[0] }}"
      {% endfor %}

    wigo-tcp:
      name: backend-wigo-tcp
      mode: tcp
      balance: source
      servers:
      {% for server, ips in wigo.items() %}
        {{ server.split('.')[0] }}:
          host: {{ ips[0] }}
          port: 4001
      {% endfor %}
