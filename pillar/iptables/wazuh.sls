iptables_custom:
  wazuh:
    chain: MYSERVICES
    chain_id: 45
    chain_type: ipv4
    table: filter
    rules:
    # For the wigo server, need a port to push data on it.
    # work on role wigo_server
      - _01:
        set:
          name: myhosts
          direction: src
        state: NEW
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 4001
        comment: "\"wigo push-server for my hosts\""
    # For the wazuh host, need some port to be opened
    # work on host name, and not on role
      - _02:
        set:
          name: myhosts
          direction: src
        state: NEW
        method: append
        jump: ACCEPT
        proto: udp
        dport: 1514
        comment: "\"ossec-remoted for my own hosts\""
      - _03:
        set:
          name: myhosts
          direction: src
        state: NEW
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 1514
        comment: "\"ossec-remoted for my own hosts\""
      - _04:
        set:
          name: myhosts
          direction: src
        state: NEW
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 1515
        comment: "\"ossec-authd for my own hosts\""
