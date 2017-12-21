iptables_custom:
  chain: MYSERVICES
  chain_id: 50
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

  # For all webserver, we may want to open 80/443 ports
  # those are standard, all host with role "webserver" will have those port open
  {% if 'webserver' in grains['roles'] %}
    - _03:
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 80
      comment: HTTP
    - _04:
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 443
      comment: HTTPS
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

  # For proxmox server, allow managament on port 8006
  # Use the role 'proxmox' for this
  {% if 'proxmox' in  grains['roles'] %}
    - _09:
      source: 109.190.254.0/26
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 8006
      comment: "\"proxmox from ovh-desk\""
    - _10:
      source: 213.186.33.64/32
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 8006
      comment: "\"proxmox from ovh-vpn\""
    - _11:
      source: 78.232.192.141/32
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 8006
      comment: "\"proxmox from home\""
  {% endif %}

  # For the wazuh host, need some port to be opened
  # work on host name, and not on role
  {% if 'wazuh_server' in grains['roles'] %}
    - _11:
      set:
        name: myhosts
        direction: src
      state: NEW
      method: append
      jump: ACCEPT
      proto: udp
      dport: 1514
      comment: "\"ossec-remoted for my own hosts\""
    - _12:
      set:
        name: myhosts
        direction: src
      state: NEW
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 1514
      comment: "\"ossec-remoted for my own hosts\""
    - _13:
      set:
        name: myhosts
        direction: src
      state: NEW
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 5601
      comment: "\"kibana for my own hosts\""
    - _14:
      set:
        name: ovh_office
        direction: src
      state: NEW
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 5601
      comment: "\"kibana for my ovh office\""
  {% endif %}

  # The default rule is to return to the master chain
  # And apply the policy of the master chain (INPUT)
  # Without this the iptables files won't compiled
    - _99:
      method: append
      jump: RETURN

