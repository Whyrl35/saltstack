{% set host = salt.grains.get('host') %}

dnsmasq:
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
