{% set ns_ipv4s = salt.saltutil.runner('mine.get', tgt='ns[0-9]*', fun='network.ip_addrs') %}
{% set my_ipv4s = salt.grains.get('ipv4', []) %}
{% set bind_keys = salt['vault'].read_secret('secret/salt/bind/keys') %}

### Keys, Zones, ACLs  ###
bind:
  keys:
    "dns_key":
      algorithm: "hmac-sha256"
      secret: "{{ bind_keys['dns_key'] }}"
    "rndc-key":
      algorithm: "hmac-sha256"
      secret: "{{ bind_keys['rndc-key'] }}"

  configured_acls:
    my_net:
      - 127.0.0.0/8
      - 10.0.0.0/16

  configured_zones:
    whyrl.fr:
      type: master
      notify: true
      auto-dnssec: 'maintain'
      allow-transfer:
        {% for name, ips in ns_ipv4s.items() %}
        {% for ip in ips %}
        {% if (ip | is_ip(options='private')) %}
        - {{ ip }}
        {% endif %}
        {% endfor %}
        {% endfor %}

    0.10.in-addr.arpa:
      type: master
      notify: true
      allow-transfer:
        {% for name, ips in ns_ipv4s.items() %}
        {% for ip in ips %}
        {% if (ip | is_ip(options='private')) %}
        - {{ ip }}
        {% endif %}
        {% endfor %}
        {% endfor %}

### Define zone records in pillar ###

  {% set serial = None | strftime("%Y%m%d%H%M") %}
  available_zones:
    whyrl.fr:
      file: whyrl.fr.txt
      soa:
        ns: ns1.whyrl.fr.
        contact: hostmaster
        serial: auto # {{ serial }}
        class: IN
        refresh: 8600
        retry: 120
        expiry: 86400
        nxdomain: 60
        ttl: 600
      records:
        NS:
          '@':
            - ns1
            - ns2
        A:
          srv001: 82.65.179.161
          ks001: 91.121.156.77
          vpn-ca: 54.39.188.136
          statping: 141.95.75.131
          ns1: 10.0.2.133
          ns2: 10.0.0.36
          smtp: 10.0.3.67
          bastion: 10.0.1.184
          truenas: 10.0.1.108
          ingress.k8s: 51.210.210.127
          {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='*', fun='network.ip_addrs').items() %}
          {% set name = fqdn | regex_replace('.whyrl.fr', '') %}
          {% for ip in ips %}
          {% if (ip | is_ip(options='private')) and (ip[0:5] == '10.0.') %}
          {{ name }}: {{ ip }}
          {% endif %}
          {% endfor %}
          {% endfor %}
        MX:
          whyrl.fr.: '1 smtp'
        TXT:
          dkim._domainkey.whyrl.fr.: 'v=DKIM1; k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDI6+mdm+MLMECQC5mJz9ISpxo6jMpQnTUL0l/oNkg348uzwHhUjYPkpwFFD8l4X6TPoEynf4DDgbYipDFChXFUyCWDGZr8tFQAT84iz7Pnyb3/OGnXeYl/H7IZyLQB/hNi1FFd7Baejbvgf4N+L+tUt8SEAPYtqpgr7oMJjp10lQIDAQAB'  # noqa: 204
          whyrl.fr.: 'v=spf1 a mx -all'
          arc._domainkey.whyrl.fr.: 'v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDI6+mdm+MLMECQC5mJz9ISpxo6jMpQnTUL0l/oNkg348uzwHhUjYPkpwFFD8l4X6TPoEynf4DDgbYipDFChXFUyCWDGZr8tFQAT84iz7Pnyb3/OGnXeYl/H7IZyLQB/hNi1FFd7Baejbvgf4N+L+tUt8SEAPYtqpgr7oMJjp10lQIDAQAB'  # noqa: 204
          _dmarc.whyrl.fr.: 'v=DMARC1; p=none; sp=reject'
        CNAME:
          ks: ks001.whyrl.fr.
          drone: drone.ingress.k8s.whyrl.fr.
          srv002: srv001.whyrl.fr.
          nas: srv001.whyrl.fr.
          hassio: srv001.whyrl.fr.
          gateway: srv001.whyrl.fr.
          portainer: srv001.whyrl.fr.

          imap.cloud: mail.whyrl.fr.
          loki: loki.cloud.whyrl.fr.
          mail.cloud: mail.whyrl.fr.
          salt: saltmaster.cloud.whyrl.fr.
          smtp.cloud: smtp.whyrl.fr.
          vault: saltmaster.cloud.whyrl.fr.
          vault.cloud: saltmaster.cloud.whyrl.fr.

          gitea: ingress.k8s.whyrl.fr.

    0.10.in-addr.arpa:
      file: whyrl.fr.rev.txt
      soa:
        ns: ns1.whyrl.fr.
        contact: hostmaster
        serial: auto # {{ serial }}
        class: IN
        refresh: 8600
        retry: 120
        expiry: 86400
        nxdomain: 60
        ttl: 600
      records:
        NS:
          '@':
             - ns1.whyrl.fr.
             - ns2.whyrl.fr.
      generate_reverse:
        net: 10.0.0.0/16
        for_zones:
          - any
