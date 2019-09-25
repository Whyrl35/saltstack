#!jinja|yaml|gpg
ipset_custom:
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
