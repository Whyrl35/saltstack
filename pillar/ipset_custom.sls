#!jinja|yaml|gpg
ipset_custom:
  bastion:
    name : bastion
    id : '00'
    ips:
      - 54.38.71.9/32         # bastion
      - 78.232.192.141/32     # srv001
      {% if grains['id'] == 'srv001.whyrl.fr' %}
      - 192.168.0.1/24        # home network (pc, laptop, tablet, tv, ....)
      {% endif %}
  myhosts:
    name : myhosts
    id : '01'
    ips :
      - 91.121.156.77/32      # ks001
      - 78.232.192.141/32     # srv001
      - 217.182.169.71/32     # vps001
      - 217.182.85.34/32      # wazuh
      - 217.182.85.80/32      # mail
      - 54.38.71.9/32         # bastion
      - 54.38.71.44/32        # rocket.chat
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
  ovh_office:
    name : ovh_office
    id : '04'
    ips:
      # OVH office
      - |
        -----BEGIN PGP MESSAGE-----

        hQIMA85QH7s0WVo+ARAAozLDIW83z4qkER/Z0MJTqZBAzhO/9kCvZRDUMKe64gw6
        G5ORw1Q5HlkXizJTeU17iqmvtqmuwTLRzBNU6h/STdz9T3P2gbOVqTnwlUrB356y
        /OI0RPo1OIG3iQEpylw8MTl8+2HA9PV85tDA9o30xZNquduBkkMU0RRzHlowHA40
        Gn44LDLO8xcgdclS7hMgKzd3SKAjWw5z/hJfqng+OoGQ1y/zQugTsvfP32LRNXDi
        W7zLdqMzG8U66XcpEbpVw+rqGD7me6NxE6RSOOGVrcdeGQAWbCfbRri3VxkSJV7F
        w59QbdYPhgfxA54GZq37BMt4ZtsQ3xVdEz4MJ5IgwQXFb5TMOmqnTdNBvNEwdgxY
        cYbSvG3NUaxHKFC/4V9bU2FgRXtsMNzwyKbCYBs9o4mfX/r70Twdi11I0Lh5D4zu
        R3uyVcj4TPQJkeZxtCiWU97TVFKUA7qAqwQLzkDawyli9NXF1KapmaNJYkiiZkq2
        rOPDlIMkjkR1Un59Ftz8nErrKf+ih7kaxArazUv1Uxlh4eXNPDBjX5Q+h5ekQg2n
        QOHCPBwmyOh3gZqhol05Wb4jRScDSDx4noH7oFvECO5wClKQzjg8Bg7BqI4GkwxX
        WPR4zVINW6IYcTnzoqHkocN+VlTQ6z0FgZUX3QDAhg6zxb8BX6EZanCzWbYC63DS
        SwGthJ1UYLYZ7M3AefsqKozNozDHhdtn9/UE/l/V3AeQ44Qv1PLxnHN3cb8PVKln
        13zoT+RldNXK4g6bYm/ZKDEPrfwu0wlj5mBYdA==
        =SBJE
        -----END PGP MESSAGE----
      # OVH vpn-out
      - |
        -----BEGIN PGP MESSAGE-----

        hQIMA85QH7s0WVo+AQ/8C4JcJ8NFKZHeEE/FyrTS782SMUpoHUlPEPgH8/ObATAj
        3lVbXaiwjCOf394t/6PneTIkkysAECtwfW2s2gDBR6WrVQ67pOxfN5oBj704i3FU
        tfBDnZkECDOx1GAeRJqxy9S29jpmTyln98W8ObX+7Mr5rAsTvBwE32Bfc00ZM748
        wRCEqP4ZQp+CyPwIZvtR1Uj98Rx3ARtzRx0OWYDBeevspx0GEZcAq1PMi+V4xOO4
        EBK4eMym2uuuyLgPPRWUJUvaCTyQIBU4ba38FeWPpyzcNeAHkFb1rpltsH8xNLQf
        rhZPz70TOrkIPD4wup3rX4DRaXH5QeHhOcyHFZ8xQuMQESjDLwIcloNrZ99O7tZj
        A2ZoDgDkgSsaDdacK8tlySXoaePe8jBAPyWj1G5NRNfAIB1vMbLfE+wXpPuDMjc3
        gzWF+836eamurqOHUiTL3BYcOYZ2t182H86EDRM3n33ie3PWoqcGE2T5/mqcCDCQ
        MNbzhNQ3MgUPn3PhiDtehN8nxN6/EfU4RgLVFpWBFa5Cocmm+Glk0WM4/zW7O8cZ
        wfk7C8fmrsCBOrAKMTi59Q34n3k7/BSAt1gk+sEXVqivG+Fhh48qv4H0f4XBljAh
        gCitkUhD8Awhoi/2vHDMQCQuoDRvl0n6b7WspO5AyDikgtzGG6xyk5J+qvJeh9nS
        SwElyQ9eoA24NOc0zc2sGfCzDCRHpd2Sj/c4Hds4lpSwmJIDxVnovXbtClAzSJWe
        Dxa6aJsKfepTPjGHlV7VKYnnROssBYGJH3Jpqg==
        =cuy3
        -----END PGP MESSAGE-----
  blacklist:
    name: blacklist
    timeout: 1800
    id : '05'
