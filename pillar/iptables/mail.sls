iptables_custom:
  mail:
    chain: MAIL
    chain_id: 55
    chain_type: ipv4
    table: filter
    rules:
      - _01:
        state: NEW,ESTABLISHED
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 25
        comment: "\"SMTP\""
      - _02:
        state: NEW,ESTABLISHED
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 993
        comment: "\"IMAP\""
