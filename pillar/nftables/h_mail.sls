nftables:
  configuration:
    "host_{{ salt['grains.get']('host') }}_specific":
      rules:
        - name: 'allow crowdsec prometheus scraping'
          table: 'filter'
          chain: 'prometheus'
          family: 'ip'
          rule: 'tcp dport { 6060, 60601 } ip saddr {  10.0.3.197/32, 51.178.63.140/32 } counter accept'
