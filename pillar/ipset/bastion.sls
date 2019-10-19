#!jinja|yaml|gpg
ipset_custom:
  bastion:
    name : bastion
    id : '00'
    ips:
      - 54.38.71.9/32         # bastion
      - 78.232.192.141/32     # srv001
      - 82.252.137.158/32     # srv001 since freebox delta (I guess it's IPv4 over IPv6 tunnel)
      {% if grains['ip4_gw'] == '192.168.0.254' %}
      - 62.240.254.57/32      # claranet ... must repair the bastion to allow connection to srv001 (may reregister the host)
      - 192.168.0.1/24        # home network (pc, laptop, tablet, tv, ....)
      {% endif %}
  bastionv6:
    name : bastionv6
    id : '00'
    family: 'inet6'
    ips:
      - 2a01:e34:ee8c:8d0::/64 # HOME (freebox, srv001, all @home computer)
      - 2001:a70:3:0:10d1:7445:3b04:e275 # CLARANET
