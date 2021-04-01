{% set short_hostname = data['id'].split('/')[0] %}
{% set domainname = 'whyrl.fr' %}

#- Set the hostname
reactor_change_hostname:
  local.cmd.run:
    - tgt: {{ data['id'] }}
    - args:
      - cmd: "/usr/bin/hostname {{ short_hostname }}"

#- Set the domainname
reactor_change_domainname:
  local.cmd.run:
    - tgt: {{ data['id'] }}
    - args:
      - cmd: "/usr/bin/domainname {{ domainname }}"

#- Refreshing pillar
reactor_sync_pillar:
  local.saltutil.sync_pillar:
    - tgt: {{ data['id'] }}

#- Delete conflicting apt source list
reactor_change_hostname:
  local.cmd.run:
    - tgt: {{ data['id'] }}
    - args:
      - cmd: "/usr/bin/rm -f /etc/apt/sources.list.d/saltstack.list"

#- Refreshing grains
reactor_sync_grains:
  local.saltutil.sync_grains:
    - tgt: {{ data['id'] }}

#- Updating the mine
reactor_mine_update:
  local.mine.update:
    - tgt: {{ data['id'] }}

#- Update wazuh to allow new IP (wazuh + wigo)
reactor_wazuh:
  local.state.apply:
    - tgt: 'roles:wazuh_server'
    - tgt_type: grain

#- Update bastion to allow new IP
reactor_bastion:
  local.state.apply:
    - tgt: 'roles:bastion'
    - tgt_type: grain

#- State apply on the new host
reactor_newhost_1:
  local.state.highstate:
    - tgt: {{ data['id'] }}

#- Add the host in bastion (?)
reactor_register_bastion:
  runner.state.orchestrate:
    - args:
      - mods: orchestrate.bastion

