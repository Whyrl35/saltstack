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
    check_process:
      enabled: 'true'
      processList: 
        - /usr/sbin/sshd
        - /usr/bin/beamium
        - /usr/bin/noderig
        - /usr/bin/salt-minion
        - /usr/bin/dockerd
        - /usr/bin/containerd