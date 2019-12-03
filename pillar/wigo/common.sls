wigo:
  probes: []
  probes_actives: []
  probes_config:
    check_process:
      enabled: 'true'
      containerList: 
        - /usr/sbin/sshd
        - /usr/bin/beamium
        - /usr/bin/noderig
        - /usr/bin/salt-minion
