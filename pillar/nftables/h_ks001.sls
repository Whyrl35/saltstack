nftables:
  configuration:
    "host_{{ salt['grains.get']('host') }}_specific":
      chains:
        - name: 'WEBHOOK'
          table: 'filter'
          family: 'ip'
        - name: 'WEBHOOK'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to WEBHOOK'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'jump WEBHOOK'
        - name: 'jump to WEBHOOK'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'jump WEBHOOK'
        - name: 'allow webhook'
          table: 'filter'
          chain: 'WEBHOOK'
          family: 'ip'
          rule: 'tcp dport 9000 counter accept'
        - name: 'allow webhook'
          table: 'filter'
          chain: 'WEBHOOK'
          family: 'ip6'
          rule: 'tcp dport 9000 counter accept'#    
