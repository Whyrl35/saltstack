#!jinja|yaml|gpg
docker:
  containers:
    running:
      - portainer
      - cadvisor
      - statping

    cadvisor:
      name: cadvisor
      image: "gcr.io/cadvisor/cadvisor:latest"
      binds:
        - /:/rootfs:ro
        - /var/run:/var/run:rw
        - /sys:/sys:ro
        - /var/lib/docker/:/var/lib/docker:ro
      port_bindings:
        - 9102:8080
      start: true
      detatch: true
      #auto_remove: true
      privilegde: true
      network_disabled: false
      network_mode: bridge
      restart_policy: always

    portainer:
      name: portainer_agent
      image: "portainer/agent:latest"
      binds:
        - /var/run/docker.sock:/var/run/docker.sock
        - /var/lib/docker/volumes:/var/lib/docker/volumes
      port_bindings:
        - 9001:9001
      start: true
      detatch: true
      #auto_remove: true
      privilegde: true
      network_disabled: false
      network_mode: bridge
      restart_policy: always

    statping:
      name: statping
      image: "adamboutcher/statping-ng"
      binds:
        - /srv/statping:/app
      port_bindings:
        - 8080:8080
      start: true
      detatch: true
      network_disabled: false
      network_mode: bridge
      restart_policy: always
