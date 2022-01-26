nftables:
  configuration:
    "host_{{ salt['grains.get']('host') }}_specific":
      chains:
        - name: 'SERVICES'
          table: 'filter'
          family: 'ip'
        - name: 'SERVICES'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to services'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'jump SERVICES'
        - name: 'jump to services'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'jump SERVICES'
