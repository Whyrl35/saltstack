reactor_refresh_pillar:
  local.saltutil.refresh_pillar:
    - tgt: {{ data['name'] }}

reactor_refresh_grains:
  local.saltutil.refresh_grains:
    - tgt: {{ data['name'] }}

reactor_newhost_1:
  local.state.apply:
    - tgt: {{ data['name'] }}

#reactor_borg:
  #  local.state.apply:
    #  - tgt: 'roles:borgbackup'
    #- tgt_type: grain

reactor_wazuh:
  local.state.apply:
    - tgt: 'roles:wazuh_server'
    - tgt_type: grain

reactor_bastion:
  local.state.apply:
    - tgt: 'roles:bastion'
    - tgt_type: grain

reactor_register_bastion:
  runner.state.orchestrate:
    - args:
      - mods: orchestrate.bastion

reactor_newhost_2:
  local.state.apply:
    - tgt: {{ data['name'] }}

