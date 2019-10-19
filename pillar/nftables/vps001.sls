nftables:
  configuration:
    "{{ salt['grains.get']('host') }}_specific":
      chains:
        - name: 'services'
          table: 'filter'
          family: 'inet'
      rules:
        - name: 'jump to services'
          table: 'filter'
          chain: 'input'
          family: 'inet'
          rule: 'jump services'
        - name: 'allow salt'
          table: 'filter'
          chain: 'services'
          family: 'inet'
          rule: 'tcp dport { 4505, 4506 } jump salt'
