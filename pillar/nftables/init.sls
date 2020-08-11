nftables:
  lookup:
    service:
      enable: true
    config: /etc/nftables.conf

include:
    - nftables.common
