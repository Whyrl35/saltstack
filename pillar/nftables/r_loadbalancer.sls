#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

nftables:
  configuration:
    "specific_loadbalancer":
      chains:
        - name: 'loadbalancer'
          table: 'filter'
          family: 'ip'
      rules:
        - name: 'jump to loadbalancer'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump loadbalancer'
        - name: 'allow stats'
          table: 'filter'
          chain: 'loadbalancer'
          family: 'ip'
          rule: 'tcp dport 8801 counter accept'
        - name: 'allow http'
          table: 'filter'
          chain: 'loadbalancer'
          family: 'ip'
          rule: 'tcp dport 80 counter accept'
        - name: 'allow https'
          table: 'filter'
          chain: 'loadbalancer'
          family: 'ip'
          rule: 'tcp dport 443 counter accept'
        - name: 'allow proxy for salt'
          table: 'filter'
          chain: 'loadbalancer'
          family: 'ip'
          rule: 'tcp dport {4505, 4506} counter accept'
        - name: 'allow proxy for webhooks'
          table: 'filter'
          chain: 'loadbalancer'
          family: 'ip'
          rule: 'tcp dport 9000 counter accept'
