nftables:
  configuration:
    "wazuh_server_specific":
      chains:
        - name: 'WAZUH'
          table: 'filter'
          family: 'ip'
        - name: 'WAZUH'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to WAZUH'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'jump WAZUH'
        - name: 'jump to WAZUH'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'jump WAZUH'
        - name: 'allow wigo tcp'
          table: 'filter'
          chain: 'WAZUH'
          family: 'ip'
          rule: 'ip saddr @myhosts tcp dport { 1514, 1515 } counter accept'
        - name: 'allow wigo udp'
          table: 'filter'
          chain: 'WAZUH'
          family: 'ip'
          rule: 'ip saddr @myhosts udp dport 1514 counter accept'
        - name: 'allow wigo tcp'
          table: 'filter'
          chain: 'WAZUH'
          family: 'ip6'
          rule: 'ip6 saddr @myhosts tcp dport { 1514, 1515 } counter accept'
        - name: 'allow wigo udp'
          table: 'filter'
          chain: 'WAZUH'
          family: 'ip6'
          rule: 'ip6 saddr @myhosts udp dport 1514 counter accept'
        - name: 'allow web'
          table: 'filter'
          chain: 'WAZUH'
          family: 'ip'
          rule: 'tcp dport { 80, 443 } counter accept'
        - name: 'allow web'
          table: 'filter'
          chain: 'WAZUH'
          family: 'ip6'
          rule: 'tcp dport { 80, 443 } counter accept'
