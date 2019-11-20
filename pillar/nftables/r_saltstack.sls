nftables:
  configuration:
    "saltstack_specific":
      chains:
        - name: 'SALTSTACK'
          table: 'filter'
          family: 'ip'
        - name: 'SALTSTACK'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to SALTSTACK'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'jump SALTSTACK'
        - name: 'jump to SALTSTACK'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'jump SALTSTACK'
        - name: 'allow webhook'
          table: 'filter'
          chain: 'SALTSTACK'
          family: 'ip'
          rule: 'tcp dport 9000 counter accept'
        - name: 'allow webhook'
          table: 'filter'
          chain: 'SALTSTACK'
          family: 'ip6'
          rule: 'tcp dport 9000 counter accept'