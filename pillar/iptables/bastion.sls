iptables_custom:
  bastion:
    chain: BASTION
    chain_id: 40
    chain_type: ipv4
    table: filter
    rules:
      - _01:
        state: NEW,ESTABLISHED
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 2222
        comment: "\"SSH Bastion\""
