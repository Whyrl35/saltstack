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
      notify: false
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
      notify: false
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
        ns: ns1.whyrl.fr
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
          test: 10.3.1.1
          {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='*', fun='network.ip_addrs').items() %}
          {% set name = fqdn | regex_replace('.whyrl.fr', '') %}
          {% for ip in ips %}
          {% if (ip | is_ip(options='private')) and (ip[0:5] == '10.3.') %}
          {{ name }}: {{ ip }}
          {% endif %}
          {% endfor %}
          {% endfor %}
    3.10.in-addr.arpa:
      file: whyrl.fr.rev.txt
      soa:
        ns: ns1.whyrl.fr
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
