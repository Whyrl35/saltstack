bind:

  configured_acls:
    my_net:
      - 127.0.0.0/8
      - 192.168.0.0/16

  configured_zones:
    ##
    ## whyrl.fr zone
    whyrl.fr:
      type: master
      notify: false
      allow-query:
        - my_net
      allow-update: 'none'
      allow-transfer:
        - my_net
      also-notify:
        - 192.168.0.2
    ##
    ## whyrl.fr reverse
    168.192.in-addr.arpa:
      type: master
      notify: false
      allow-query:
        - my_net
      allow-update: 'none'
      allow-transfer:
        - my_net
      also-notify:
        - 192.168.0.2

  available_zones:
    ##
    ## whyrl.fr zone
    whyrl.fr:
      file: db.whyrl.fr
      soa:
        ns: localhost
        contact: root.whyrl.fr
        serial: 2019122001
        class: IN
        refresh: 8640
        retry: 900
        expiry: 86400
        nxdomain: 600
        ttl: 3600
      records:
        A:
          # LOCAL
          srv002: 192.168.0.1
          nas: 192.168.0.2
          printer: 192.168.0.6
          netatmo: 192.168.0.8
          freebox-player: 192.168.0.200
          freebox-player: 192.168.0.201
          camera-salon: 192.168.0.202
          ex6100: 192.168.0.253
          gateway: 192.168.0.254
          # EXT
          # TODO : generate from mine the list of Name/IPv4 couple
        AAAA:
          # LOCAL
          srv002: 2a01:e34:ee8c:8d0:6a1d:efff:fe11:3819
          nas: 2a01:e34:ee8c:8d0:211:32ff:fe47:9b23
          # EXT
          # TODO : generate from mine the list of Name/IPv6 couple
        CNAME:
          # LOCAL
          srv001: srv002.whyrl.fr.
          www: srv002.whyrl.fr.
          hassio: srv002.whyrl.fr.
          homepanel: srv002.whyrl.fr.
          ssh: srv002.whyrl.fr.
          ftp: srv002.whyrl.fr.
          portainer: srv002.whyrl.fr.
          extend: ex6100.whyrl.fr.
          # EXT
          '*.ks': ks001.whyrl.fr.
          ks: ks001.whyrl.fr.
          wigo: wazuh.whyrl.fr.
          smtp: mail.whyrl.fr.
          imap: mail.whyrl.fr.
          postfixadmin: mail.whyrl.fr.
          webmail: mail.whyrl.fr.
          rspamd: mail.whyrl.fr.
          salt: saltmaster.whyrl.fr.
          saltpad: saltmaster.whyrl.fr.
        NS:
          '@':
            - srv001

    ##
    ## whyrl.fr reverse
    168.192.in-addr.arpa:
      soa:
        ns: localhost
        contact: root.whyrl.fr
        serial: 2019122001
        class: IN
        refresh: 8640
        retry: 900
        expiry: 86400
        nxdomain: 600
        ttl: 3600
      records:
        NS:
          '@':
            - srv001
      generate_reverse:
        net: 192.168.0.0/16
        for_zones:
          - whyrl.fr
