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
  {% if 'webserver' in grains['roles'] or 'mail_server' in grains['roles'] %}
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

  # For the wigo server, need a port to push data on it.
  # work on role wigo_server
  {% if 'wigo_server' in grains['roles'] %}
    - _08:
      set:
        name: myhosts
        direction: src
      state: NEW
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 4001
      comment: "\"wigo push-server for my hosts\""
    - _09:
      set:
        name: myhosts
        direction: src
      state: NEW
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 4000
      comment: "\"wigo http from myhosts\""
    - _09:
      set:
        name: ovh_office
        direction: src
      state: NEW
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 4000
      comment: "\"wigo http from ovh_office\""
  {% endif %}

  # For the wazuh host, need some port to be opened
  # work on host name, and not on role
  {% if 'wazuh_server' in grains['roles'] %}
    - _12:
      set:
        name: myhosts
        direction: src
      state: NEW
      method: append
      jump: ACCEPT
      proto: udp
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
      dport: 1514
      comment: "\"ossec-remoted for my own hosts\""
    - _14:
      set:
        name: myhosts
        direction: src
      state: NEW
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 5601
      comment: "\"kibana for my own hosts\""
    - _15:
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

  {% if 'mail_server' in grains['roles'] %}
    - _16:
      state: NEW,ESTABLISHED
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 25
      comment: "\"SMTP\""
  {% endif %}

  # The default rule is to return to the master chain
  # And apply the policy of the master chain (INPUT)
  # Without this the iptables files won't compiled
    - _99:
      method: append
      jump: RETURN

