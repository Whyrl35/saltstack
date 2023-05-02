#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

nftables:
  configuration:
    "specific_dns":
      chains:
        - name: 'dns'
          table: 'filter'
          family: 'ip'
      rules:
        - name: 'jump to dns'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump dns'
        - name: 'allow dns TCP'
          table: 'filter'
          chain: 'dns'
          family: 'ip'
          rule: 'ip saddr 10.0.0.0/16 tcp dport 53 counter accept'
        - name: 'allow dns UDP'
          table: 'filter'
          chain: 'dns'
          family: 'ip'
          rule: 'ip saddr 10.0.0.0/16 udp dport 53 counter accept'
        - name: 'allow bind exporter prometheus scraping'
          table: 'filter'
          chain: 'prometheus'
          family: 'ip'
          rule: 'tcp dport { 9119 } ip saddr { 10.0.3.197/32, 51.178.63.140/32 } counter accept'
