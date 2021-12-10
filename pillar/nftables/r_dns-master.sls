#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

nftables:
  configuration:
    "specific_dns":
      chains:
        - name: 'DNS'
          table: 'filter'
          family: 'ip'
      rules:
        - name: 'jump to DNS'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'jump DNS'
        - name: 'allow dns TCP'
          table: 'filter'
          chain: 'DNS'
          family: 'ip'
          rule: 'ip saddr 10.3.0.0/16 tcp dport 53 counter accept'
        - name: 'allow dns UDP'
          table: 'filter'
          chain: 'DNS'
          family: 'ip'
          rule: 'ip saddr 10.3.0.0/16 udp dport 53 counter accept'
