#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

nftables:
  configuration:
    "specific_firezone":
      chains:
        - name: 'FIREZONE'
          table: 'filter'
          family: 'ip'
        - name: 'FIREZONE'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to FIREZONE'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'jump FIREZONE'
        - name: 'jump to FIREZONE'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'jump FIREZONE'
        - name: 'allow web'
          table: 'filter'
          chain: 'FIREZONE'
          family: 'ip'
          rule: 'tcp dport { 80, 443 } counter accept'
        - name: 'allow web'
          table: 'filter'
          chain: 'FIREZONE'
          family: 'ip6'
          rule: 'tcp dport { 80, 443 } counter accept'
        - name: 'allow wiregard'
          table: 'filter'
          chain: 'FIREZONE'
          family: 'ip'
          rule: 'udp dport 51820 counter accept'
        - name: 'allow wiregard'
          table: 'filter'
          chain: 'FIREZONE'
          family: 'ip6'
          rule: 'udp dport 51820 counter accept'
