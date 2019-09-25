# For all webserver, we may want to open 80/443 ports
# those are standard, all host with role "webserver" will have those port open
iptables_custom:
  webserver:
    chain: WEBSERVER
    chain_id: 51
    chain_type: ipv4
    table: filter
    rules:
      - _01:
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 80
        comment: HTTP
      - _02:
        method: append
        jump: ACCEPT
        proto: tcp
        dport: 443
        comment: HTTPS
