#!jinja|yaml|gpg
{% set secret = salt['vault'].read_secret('secret/salt/portainer/edge/docker01.cloud.whyrl.fr') %}

docker:
  containers:
    running:
      - portainer

    portainer:
      name: portainer_edge_agent
      image: "portainer/agent:latest"
      binds:
        - /var/run/docker.sock:/var/run/docker.sock
        - /var/lib/docker/volumes:/var/lib/docker/volumes
        - /:/host
        - portainer_agent_data:/data
      env:
        - EDGE=1
        - EDGE_ID={{ secret['id'] }}
        - EDGE_KEY={{ secret['key'] }}
        - EDGE_INSECURE_POLL=1
      start: true
      detatch: true
      #auto_remove: true
      privilegde: true
      network_disabled: false
      network_mode: bridge
      restart_policy: always

