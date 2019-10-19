nftables:
  lookup:
    service:
      enable: true
    config: /etc/nftables.conf

include:
    - nftables.common
    - nftables.{{ salt.grains.get('host') }}
