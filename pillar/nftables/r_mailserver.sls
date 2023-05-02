nftables:
  configuration:
    "mail_server_specific":
      chains:
        - name: 'mail'
          table: 'filter'
          family: 'ip'
        - name: 'mail'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to mail'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump mail'
        - name: 'jump to mail'
          table: 'filter'
          chain: 'input'
          family: 'ip6'
          rule: 'jump mail'
        - name: 'allow smtp and imap'
          table: 'filter'
          chain: 'mail'
          family: 'ip'
          rule: 'tcp dport { 25, 587, 993 } counter accept'
        - name: 'allow smtp and imap'
          table: 'filter'
          chain: 'mail'
          family: 'ip6'
          rule: 'tcp dport { 25, 587, 993 } counter accept'
        - name: 'allow postfix exporter prometheus scraping'
          table: 'filter'
          chain: 'prometheus'
          family: 'ip'
          rule: 'tcp dport { 9154 } ip saddr { 10.0.3.197/32, 51.178.63.140/32 } counter accept'

      set_elements:
        - name: 'blacklist censys ipv4'
          table: 'filter'
          family: 'ip'
          set: 'blacklist'
          elements:
            - 162.142.125.0/24
            - 167.94.138.0/24
            - 167.94.145.0/24
            - 167.94.146.0/24
            - 167.248.133.0/24
        - name: 'blacklist censys ipv6'
          table: 'filter'
          family: 'ip6'
          set: 'blacklist'
          elements:
            - 2602:80d:1000:b0cc:e::/80
            - 2620:96:e000:b0cc:e::/80
