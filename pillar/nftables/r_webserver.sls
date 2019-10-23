nftables:
  configuration:
    "webserver_specific":
      chains:
        - name: 'WEB'
          table: 'filter'
          family: 'ip'
        - name: 'WEB'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to WEB'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'jump WEB'
        - name: 'jump to WEB'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'jump WEB'
        - name: 'allow web'
          table: 'filter'
          chain: 'WEB'
          family: 'ip'
          rule: 'tcp dport { 80, 443 } counter accept'
        - name: 'allow web'
          table: 'filter'
          chain: 'WEB'
          family: 'ip6'
          rule: 'tcp dport { 80, 443 } counter accept'

