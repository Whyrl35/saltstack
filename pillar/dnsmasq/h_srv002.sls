dnsmasq:
  # settings:
    # local=/whyrl.fr/
    # domain=whyrl.fr
  hosts:
    whyrl.fr:
      srv002:
        - 192.168.0.1
        - "2a01:e34:ee8c:8d0:6a1d:efff:fe11:3819"
      nas:
        - 192.168.0.2
        - "2a01:e34:ee8c:8d0:211:32ff:fe47:9b23"
      printer: 192.168.0.6
      netatmo: 192.168.0.5
      freebox-player:
        - 192.168.0.200
        - 192.168.0.201
      camera-salon: 192.168.0.202
      camera-salle: 192.168.0.203
      repeteur: 192.168.0.252
      gateway: 192.168.0.254

  cnames:
    whyrl.fr:
      srv001: srv002.whyrl.fr
      www: srv002.whyrl.fr
      hassio: srv002.whyrl.fr
      homepanel: srv002.whyrl.fr
      ssh: srv002.whyrl.fr
      portainer: srv002.whyrl.fr
