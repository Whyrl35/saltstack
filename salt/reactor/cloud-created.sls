reactor_borg:
  cmd.state.apply:
    - tgt: 'roles:borgbackup'
    - tgt_type: grain

reactor_wazuh:
  cmd.state.apply:
    - tgt: 'roles:wazuh_server'
    - tgt_type: grain

reactor_bastion:
  cmd.state.apply:
    - tgt: 'roles:bastion'
    - tgt_type: grain

reactor_register_bastion:
  runner.state.orchestrate:
    - args:
      - mods: orchestrate.bastion

reactor_bastion:
  cmd.state.apply:
    - tgt: {{ data['id'] }}

