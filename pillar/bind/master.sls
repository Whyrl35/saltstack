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
      - 10.3.0.0/16

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

    3.10.in-addr.arpa:
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
        contact: hostmaster.example.com
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
          lb-rr.web:
            {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='lb*', fun='network.ip_addrs').items() %}
            {% for ip in ips %}
            {% if (ip | is_ip(options='private')) and (ip[0:5] == '10.3.') %}
            - {{ ip }}
            {% endif %}
            {% endfor %}
            {% endfor %}
          {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='*', fun='network.ip_addrs').items() %}
          {% set name = fqdn | regex_replace('.whyrl.fr', '') %}
          {% for ip in ips %}
          {% if (ip | is_ip(options='private')) and (ip[0:5] == '10.3.') %}
          {{ name }}: {{ ip }}
          {% endif %}
          {% endfor %}
          {% endfor %}
        MX:
          whyrl.fr.: '1 smtp'
        TXT:
          dkim._domainkey.whyrl.fr.: 'v=DKIM1; k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCia87DUjVU6UeAO1Z//ZHk4xb5BhBK5W7zJ0GkzAA45OJ+bQwmRb6BCZyqHr0p2rDK85AxRZW8iA+5gePSciNitlKOyKsrZM7eDROZJfAWfmjvZuCv4FwwqELovegSyUthH8+6RFSfsnfjIkv0gXuT5wQRCAoT+rXJ8ud5YnCQFwIDAQAB'
          whyrl.fr.: 'v=spf1 a mx -all'
          arc._domainkey.whyrl.fr.: 'v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCia87DUjVU6UeAO1Z//ZHk4xb5BhBK5W7zJ0GkzAA45OJ+bQwmRb6BCZyqHr0p2rDK85AxRZW8iA+5gePSciNitlKOyKsrZM7eDROZJfAWfmjvZuCv4FwwqELovegSyUthH8+6RFSfsnfjIkv0gXuT5wQRCAoT+rXJ8ud5YnCQFwIDAQAB'
          _dmarc.whyrl.fr.: 'v=DMARC1; p=none; sp=reject'
        CNAME:
          salt: saltmaster.whyrl.fr.
          wigo: wazuh.whyrl.fr.
          saltpad: saltmaster.whyrl.fr.
          imap: mail.whyrl.fr.
          smtp: mail.whyrl.fr.
          grafana: warp10.whyrl.fr.
          srv002: srv001.whyrl.fr.
          nas: srv001.whyrl.fr.
          ks: ks001.whyrl.fr.
          uptime: probe1.smokeping.whyrl.fr.
          sshportal: bastion.whyrl.fr.
          hassio: srv001.whyrl.fr.
          gateway.whyrl.fr: srv001.whyrl.fr.
          portainer: srv001.whyrl.fr.
          webmail: mail.whyrl.fr.
          saltui: saltmaster.whyrl.fr.
          blog: lb-rr.web.whyrl.fr.

    3.10.in-addr.arpa:
      file: whyrl.fr.rev.txt
      soa:
        ns: ns1.whyrl.fr.
        contact: hostmaster.whyrl.fr
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
        net: 10.3.0.0/16
        for_zones:
          - any
