iptables_custom:
  common:
    chain: MYSERVICES
    chain_id: 99
    chain_type: ipv4
    table: filter
    rules:

    # Allow saltstack client/server port
    # Only usefull on salt-master
    {% if 'saltstack' in grains['roles'] %}
      - _01:
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 4505
        comment: saltstack
      - _02:
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 4506
        comment: saltstack
    {% endif %}

    # For local dns, dns that manage a private/local zone
    # Need to open port 53 upd/tcp for the role 'local_dns'
    {% if 'local_dns' in  grains['roles'] %}
      - _06:
        source: 192.168.0.1/24
        method: append
        jump: ACCEPT
        proto: udp
        dport: 53
        comment: DNS
      - _07:
        source: 192.168.0.1/24
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 53
        comment: DNS
    {% endif %}

    # The default rule is to return to the master chain
    # And apply the policy of the master chain (INPUT)
    # Without this the iptables files won't compiled
      - _99:
        method: append
        jump: RETURN
