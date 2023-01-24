{% set primaries = salt.saltutil.runner('mine.get', tgt='ns1*', fun='network.ip_addrs') %}
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
      type: slave
      notify: true
      auto-dnssec: 'maintain'
      masters:
        {% for name, ips in primaries.items() %}
        {% for ip in ips %}
        {% if (ip | is_ip(options='private')) %}
        - {{ ip }}
        {% endif %}
        {% endfor %}
        {% endfor %}

    0.10.in-addr.arpa:
      type: slave
      notify: true
      masters:
        {% for name, ips in primaries.items() %}
        {% for ip in ips %}
        {% if (ip | is_ip(options='private')) %}
        - {{ ip }}
        {% endif %}
        {% endfor %}
        {% endfor %}

### Define zone records in pillar ###

  available_zones:
    whyrl.fr:
      file: whyrl.fr.txt
    0.10.in-addr.arpa:
      file: whyrl.fr.rev.txt
