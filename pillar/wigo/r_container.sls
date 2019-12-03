wigo:
  probes:
    - docker_container
  probes_actives:
    docker_container: 60
  probes_config:
    docker_container:
      enabled: 'true'
      containerList: 
        - portainer
