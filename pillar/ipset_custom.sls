ipset_custom:
  myhosts:
    name : myhosts
    id : '01'
    ips :
      - 91.121.156.77/32      # ks001
      - 78.232.192.141/32     # srv001
      - 217.182.169.71/32     # vps001
      - 193.70.35.79/32       # sd001
      {% if grains['id'] == 'srv001.whyrl.fr' %}
      - 192.168.0.1/24        # home network (pc, laptop, tablet, tv, ....)
      {% endif %}
  monitoring_ssh:
    name : monitoring_ssh
    id : '02'
    ips :
      - 92.222.184.0/24       # OVH monito
      - 92.222.185.0/24       # OVH monito
      - 92.222.186.0/24       # OVH monito
      - 167.114.37.0/24       # OVH monito
      - 151.80.118.108/32     # OVH monito
  monitoring_ping:
    name : monitoring_ping
    id : '03'
    ips :
      - 92.222.184.0/24       # OVH monito
      - 92.222.185.0/24       # OVH monito
      - 92.222.186.0/24       # OVH monito
      - 167.114.37.0/24       # OVH monito
      - 151.80.118.108/32     # OVH monito
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
  ovh_office:
    name : ovh_office
    id : '04'
    ips:
      - 109.190.254.0/26      # OVH office
      - 213.186.33.64/32      # OVH vpn-out


