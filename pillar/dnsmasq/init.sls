{% set host = salt.grains.get('host') %}

dnsmasq:
  service: 'dnsmasq'
  dnsmasq_conf: '/etc/dnsmasq.conf'
  dnsmasq_conf_dir: '/etc/dnsmasq.d'
  dnsmasq_hosts: '/etc/dnsmasq.hosts'
  dnsmasq_cnames: '/etc/dnsmasq.d/cnames.conf'
  dnsmasq_addresses: '/etc/dnsmasq.d/addresses.conf'
  group: 'root'

  settings:
    port: 53
    bogus-priv: True
    # domain-needed: True
    expand-hosts: True
    no-resolv: True
    no-hosts: True
    server:
      - 192.168.0.254
      - 1.1.1.1
    cache-size: 600

include:
  - dnsmasq.h_{{ host }}
