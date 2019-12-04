wigo:
  probes:
    borg_backup: true
  {% if ('roles' in pillar) and ('borgbackup' not in pillar['roles']) %}
  probes_actives:
    probes_actives:
      borg_backup: 60
  {% else %}
  probes_actives: {}
  {% endif %}
  probes_config:
    check_process:
      enabled: 'true'
      processList: 
        - /usr/sbin/sshd
        - /usr/bin/beamium
        - /usr/bin/noderig
        - /usr/bin/salt-minion
