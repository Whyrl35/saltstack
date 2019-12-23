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
    interface:
      - lo
      - eth0
    bogus-priv: True
    domain-needed: True
    expand-hosts: True
    no-resolv: True
    server:
      - 1.1.1.1
      - 9.9.9.9
    cache-size: 600

include:
  - dnsmasq.h_{{ host }}
