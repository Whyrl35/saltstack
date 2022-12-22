#!jinja|yaml|gpg
docker:
  containers:
    running:
      - portainer

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
