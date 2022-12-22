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
