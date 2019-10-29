nftables:
  configuration:
    "host_{{ salt['grains.get']('host') }}_specific":
      set_elements:
        - name: 'bastion_elements'
          table: 'filter'
          family: 'ip'
          set: 'bastion'
          elements:
            - 192.168.0.1/24     #  local network
