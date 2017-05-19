iptables_custom:
  chain: MYSERVICES
  chain_id: 50
  chain_type: ipv4
  table: filter
  {% if grains['id'] == 'vps.whyrl.fr' %}
  rules:
    - _01:
      method: append
      jump: ACCEPT
      proto: tcp
      #source: '0.0.0.0'
      #dest: '0.0.0.0'
      #sport: 1025-65535
      dport: 80
      comment: HTTP
    - _02:
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 443
      comment: HTTPS
    - _03:
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 4505
      comment: saltstack
    - _04:
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 4506
      comment: saltstack
    - _99:
      method: append
      jump: DROP
  {% elif  grains['id'] == 'ks001.whyrl.fr' %}
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
    - _03:
      method: append
      jump: ACCEPT
      proto: tcp
      dport: 2222
      comment: GITLAB
    - _99:
      method: append
      jump: DROP
  {% elif  grains['id'] == 'srv001.whyrl.fr' %}
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
    - _99:
      method: append
      jump: DROP
  {% else %}
  rules:
  {% endif %}

