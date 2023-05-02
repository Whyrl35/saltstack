#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

nftables:
  configuration:
    "specific_wireguard":
      tables:
        - name: 'nat'
          family: 'ip'
        - name: 'nat'
          family: 'ip6'
      chains:
        - name: 'wireguard'
          table: 'filter'
          family: 'ip'
        - name: 'wireguard'
          table: 'filter'
          family: 'ip6'
        - name: 'postrouting'
          table: 'nat'
          family: 'ip'
          hook: 'postrouting'
          priority: 100
          table_type: 'nat'
          policy: 'accept'
        - name: 'postrouting'
          table: 'nat'
          family: 'ip6'
          hook: 'prerouting'
          priority: 100
          table_type: 'nat'
          policy: 'accept'
      rules:
        - name: 'jump to wireguard'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump wireguard'
        - name: 'jump to wireguard'
          table: 'filter'
          chain: 'input'
          family: 'ip6'
          rule: 'jump wireguard'
        - name: 'allow wiregard'
          table: 'filter'
          chain: 'wireguard'
          family: 'ip'
          rule: 'udp dport 51820 counter accept'
        - name: 'allow wiregard'
          table: 'filter'
          chain: 'wireguard'
          family: 'ip6'
          rule: 'udp dport 51820 counter accept'
        - name: 'allow forward'
          table: 'filter'
          chain: 'forward'
          family: 'ip'
          rule: 'ip saddr 192.168.254.0/24 counter accept'
        - name: 'nat wireguard traffic'
          table: 'nat'
          chain: 'postrouting'
          family: 'ip'
          rule: 'iifname wg0 oif ens3 masquerade'
