{% set tag = salt.pillar.get('event_tag') %}
{% set data = salt.pillar.get('event_data') %}

#- Refreshing grains
orchestate_sync_grains_init:
  salt.function:
    - name: saltutil.sync_all
    - tgt: {{ data['name'] }}

#- Refreshing pillar
orchestate_sync_pillar:
  salt.function:
    - name: saltutil.sync_all
    - tgt: {{ data['name'] }}

#- Delete conflicting apt source list
orchestate_delete_apt_source_conflict:
  salt.function:
    - name: file.remove
    - tgt: {{ data['name'] }}
    - arg:
      - /etc/apt/sources.list.d/saltstack.list

#- Refreshing grains
orchestate_sync_grains:
  salt.function:
    - name: saltutil.sync_all
    - tgt: {{ data['name'] }}

#- Update the mine
orchestate_update_mine:
  salt.runner:
    - name: mine.update
    - tgt: {{ data['name'] }}

#- Upadte wazuh to allow new IP (wazuh + wigo)
orchestrate_highstate_wazuh:
  salt.state:
    - tgt: 'roles:wazuh_server'
    - tgt_type: grain
    - highstate: true
    - onlyif:
      - fun: grains.equals
        key: cloud_fresh_install
        value: True

#- Upadte bastion to allow new IP
orchestrate_highstate_bastion:
  salt.state:
    - tgt: 'roles:bastion'
    - tgt_type: grain
    - highstate: true
    - onlyif:
      - fun: grains.equals
        key: cloud_fresh_install
        value: True

#- Highstate on new host
orchestrate_highstate_new_host:
  salt.state:
    - tgt: {{ data['name'] }}
    - highstate: true

#- Add host in bastion
orchestrate_register_bastion:
  salt.runner:
    - name: state.orchestrate
    - mods: orchestrate.bastion

#- change the fresh cloud install status
orchestrate_check_fresh_cloud_install:
  salt.function:
    - name: grains.set
    - tgt: {{ data['name'] }}
    - kwarg:
        key: cloud_fresh_install
        val: False
