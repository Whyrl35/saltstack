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
  monitoring_ssh:
    name : monitoring_ssh
    id : '02'
    ips :
      - 92.222.184.0/24       # OVH monito
      - 92.222.185.0/24       # OVH monito
      - 92.222.186.0/24       # OVH monito
      - 167.114.37.0/24       # OVH monito
      - 151.80.118.108/32     # OVH monito
      - 213.186.33.0/24       # OVH monito
  monitoring_ping:
    name : monitoring_ping
    id : '03'
    ips :
      - 92.222.184.0/24       # OVH monito
      - 92.222.185.0/24       # OVH monito
      - 92.222.186.0/24       # OVH monito
      - 167.114.37.0/24       # OVH monito
      - 151.80.118.108/32     # OVH monito
      - 213.186.33.0/24       # OVH monito
      - 69.162.124.224/28     # UPTIMEROBOT #
      - 63.143.42.240/28      # UPTIMEROBOT #
      - 46.137.190.132/32     # UPTIMEROBOT #
      - 122.248.234.23/32     # UPTIMEROBOT #
      - 188.226.183.141/32    # UPTIMEROBOT #
      - 178.62.52.237/32      # UPTIMEROBOT #
      - 54.79.28.129/32       # UPTIMEROBOT #
      - 54.94.142.218/32      # UPTIMEROBOT #
      - 104.131.107.63/32     # UPTIMEROBOT #
      - 54.67.10.127/32       # UPTIMEROBOT #
      - 54.64.67.106/32       # UPTIMEROBOT #
      - 159.203.30.41/32      # UPTIMEROBOT #
      - 46.101.250.135/32     # UPTIMEROBOT #
  blacklist:
    name: blacklist
    timeout: 1800
    id : '05'
