{% set tag = salt.pillar.get('event_tag') %}
{% set data = salt.pillar.get('event_data') %}
{% set short_hostname = data['id'].split('.')[0] %}
{% set domainname = 'whyrl.fr' %}

#- Wait for agent installation
orchestrate_wait_agent_installation:
  salt.function:
    - name: cmd.run
    - tgt: {{ data['id'] }}
    - tgt_type: grain
    - arg:
      - "sleep 120"

#- Set the hostname
orchestrate_change_hostname:
  salt.function:
    - name: cmd.run
    - tgt: {{ data['id'] }}
    - arg:
      - "/usr/bin/hostname {{ short_hostname }}"

#- Set the domainname
orchestrate_change_domainname:
  salt.function:
    - name: cmd.run
    - tgt: {{ data['id'] }}
    - arg:
      - "/usr/bin/domainname {{ domainname }}"

#- Refreshing pillar
orchestate_sync_pillar:
  salt.function:
    - name: saltutil.sync_all
    - tgt: {{ data['id'] }}

#- Delete conflicting apt source list
orchestate_delete_apt_source_conflict:
  salt.function:
    - name: cmd.run
    - tgt: {{ data['id'] }}
    - arg:
      - "/usr/bin/rm -f /etc/apt/sources.list.d/saltstack.list"

#- Refreshing grains
orchestate_sync_grains:
  salt.function:
    - name: saltutil.sync_all
    - tgt: {{ data['id'] }}

#- Update the mine
orchestate_update_mine:
  salt.runner:
    - name: mine.update
    - tgt: {{ data['id'] }}

#- Upadte wazuh to allow new IP (wazuh + wigo)
orchestrate_highstate_wazuh:
  salt.state:
    - tgt: 'roles:wazuh_server'
    - tgt_type: grain
    - highstate: true

#- Upadte bastion to allow new IP
orchestrate_highstate_bastion:
  salt.state:
    - tgt: 'roles:bastion'
    - tgt_type: grain
    - highstate: true

#- Highstate on new host
orchestrate_highstate_new_host:
  salt.state:
    - tgt: {{ data['id'] }}
    - highstate: true

#- Add host in bastion
orchestrate_register_bastion:
  salt.runner:
    - name: state.orchestrate
    - mods: orchestrate.bastion
