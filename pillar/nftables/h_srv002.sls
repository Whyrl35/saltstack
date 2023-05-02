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
      chains:
        - name: 'homeassistant'
          table: 'filter'
          family: 'ip'
      rules:
        - name: 'jump to homeassistant'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump homeassistant'
        - name: 'authorize systemd-journal-gatewayd and systemd-journal-remote'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'tcp dport { 19531, 19532 }'
        - name: 'allow crowdsec prometheus scraping'
          table: 'filter'
          chain: 'prometheus'
          family: 'ip'
          rule: 'tcp dport { 6060, 60601 } ip saddr {  10.0.3.197/32, 51.178.63.140/32 } counter accept'
