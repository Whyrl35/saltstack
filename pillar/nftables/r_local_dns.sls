nftables:
  configuration:
    "dns_server_specific":
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
        - name: 'allow dns tcp'
          table: 'filter'
          chain: 'dns'
          family: 'ip'
          rule: 'tcp dport 53 accept'
        - name: 'allow dns udp'
          table: 'filter'
          chain: 'dns'
          family: 'ip'
          rule: 'udp dport 53 accept'
