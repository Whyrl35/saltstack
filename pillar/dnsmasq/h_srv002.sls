dnsmasq:
  # settings:
    # local=/whyrl.fr/
    # domain=whyrl.fr
  hosts:
    whyrl.fr:
      srv002: 192.168.0.1
      nas: 192.168.0.1
      srv003: 192.168.0.3
      netatmo: 192.168.0.5
      printer: 192.168.0.6
      freebox-player: 192.168.0.200
      camera-salon: 192.168.0.202
      camera-salle: 192.168.0.203
      eufy: 192.168.0.210
      gateway: 192.168.0.254

  cnames:
    whyrl.fr:
      srv001: srv002.whyrl.fr
      hassio: srv002.whyrl.fr
      ssh: srv002.whyrl.fr
      portainer: srv002.whyrl.fr
