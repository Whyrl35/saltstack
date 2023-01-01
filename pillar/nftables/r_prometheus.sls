nftables:
  configuration:
    "prometheus_server_specific":
      chains:
        - name: 'prometheus'
          table: 'filter'
          family: 'ip'
      rules:
        - name: 'jump to prometheus'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump prometheus'
        - name: 'allow prometheus'
          table: 'filter'
          chain: 'prometheus'
          family: 'ip'
          rule: 'tcp dport { 9090, 9093, 9094 } ip saddr @myhosts counter accept'
