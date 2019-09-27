iptables_custom:
  portainer:
    chain: PORTAINER
    chain_id: 80
    chain_type: ipv4
    table: filter
    rules:
      - _01:
        state: NEW,ESTABLISHED
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 9001
        source: 78.232.192.141
        comment: "\"portainter agent\""
