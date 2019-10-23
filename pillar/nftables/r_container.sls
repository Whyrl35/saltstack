nftables:
  configuration:
    "container_specific":
      chains:
        - name: 'CONTAINER'
          table: 'filter'
          family: 'ip'
        - name: 'CONTAINER'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to CONTAINER'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'jump CONTAINER'
        - name: 'jump to CONTAINER'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'jump CONTAINER'
        - name: 'allow portainer'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip'
          rule: 'ip saddr @myhosts tcp dport 9001 counter accept'
        - name: 'allow portainer'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip6'
          rule: 'ip6 saddr @myhosts tcp dport 9001 counter accept'


