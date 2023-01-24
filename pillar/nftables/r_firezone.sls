#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

nftables:
  configuration:
    "specific_firezone":
      chains:
        - name: 'firezone'
          table: 'filter'
          family: 'ip'
        - name: 'firezone'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to firezone'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump firezone'
        - name: 'jump to firezone'
          table: 'filter'
          chain: 'input'
          family: 'ip6'
          rule: 'jump firezone'
        - name: 'allow web'
          table: 'filter'
          chain: 'firezone'
          family: 'ip'
          rule: 'tcp dport { 80, 443 } counter accept'
        - name: 'allow web'
          table: 'filter'
          chain: 'firezone'
          family: 'ip6'
          rule: 'tcp dport { 80, 443 } counter accept'
        - name: 'allow wiregard'
          table: 'filter'
          chain: 'firezone'
          family: 'ip'
          rule: 'udp dport 51820 counter accept'
        - name: 'allow wiregard'
          table: 'filter'
          chain: 'firezone'
          family: 'ip6'
          rule: 'udp dport 51820 counter accept'
