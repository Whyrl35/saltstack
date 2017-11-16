iptables_custom:
  chain: MYSERVICES
  chain_id: 50
  chain_type: ipv4
  table: filter
  rules:
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
  {% if 'gitlab' in  grains['roles'] %}
    - _05:
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 2222
      comment: GITLAB
  {% endif %}
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
    - _10:
      source: 78.232.192.141/32
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 8006
      comment: "\"proxmox from home\""
  {% endif %}
    - _99:
      method: append
      jump: DROP

