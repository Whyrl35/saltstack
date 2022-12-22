nftables:
  configuration:
    "saltstack_specific":
      chains:
        - name: 'saltstack'
          table: 'filter'
          family: 'ip'
      rules:
        - name: 'jump to saltstack'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump saltstack'
        - name: 'allow webhook'
          table: 'filter'
          chain: 'saltstack'
          family: 'ip'
          rule: 'tcp dport 9000 counter accept'
        - name: 'allow saltstack'
          table: 'filter'
          chain: 'saltstack'
          family: 'ip'
          rule: 'tcp dport { 4505, 4506 } counter accept'
