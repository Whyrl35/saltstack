#!jinja|yaml|gpg
ipset_custom:
  myhosts:
    name : myhosts
    id : '01'
    ips :
      - 91.121.156.77/32      # ks001
      - 78.232.192.141/32     # srv001
      - 82.252.137.158/32     # srv001 since freebox delta (why???)
      - 217.182.169.71/32     # vps001
      - 217.182.85.34/32      # wazuh
      - 217.182.85.80/32      # mail
      - 54.38.71.9/32         # bastion
      {% if grains['ip4_gw'] == '192.168.0.254' %}
      - 192.168.0.1/24        # home network (pc, laptop, tablet, tv, ....)
      {% endif %}
  myhostsv6:
    name : myhostsv6
    id : '01'
    family: 'inet6'
    ips :
      - 2a01:e34:ee8c:8d0::/64  # HOME (freebox, srv001, all @home computer)
      - 2001:41d0:1:dd4d::1/128 # ks001
