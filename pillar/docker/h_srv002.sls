docker:
  containers:
    running:
      - portainer

    portainer:
      name: portainer
      image: "portainer/portainer-ce:latest"
      binds:
        - /srv/portainer/data:/data
        - /var/run/docker.sock:/var/run/docker.sock
      port_bindings:
        - 8000:8000
        - 9000:9000
      start: true
      detatch: true
      auto_remove: true
      privilegde: true
      network_disabled: false
      network_mode: host
