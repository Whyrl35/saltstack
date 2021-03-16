{% set roles = salt.grains.get('roles', []) %}

wigo:
  probes:
    restic: true
  probes_actives:
    restic: 300
  probes_config:
    check_process:
      enabled: 'true'
      processList:
        - /usr/sbin/sshd
        - /usr/bin/beamium
        - /usr/bin/noderig
        - /usr/bin/salt-minion
