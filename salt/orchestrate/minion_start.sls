{% set tag = salt.pillar.get('event_tag') %}
{% set data = salt.pillar.get('event_data') %}
{% set id = tag.split('/')[2] %}
{% set short_name = id.split('.')[0] %}
{% set domain_name = id|replace(short_name, '')|replace('.', '', 1) %}

#- In case of fresh install, there is a highstate progressing, wait
orchestrate_wait_init:
  salt.function:
    - name: cmd.run
    - tgt: {{ id }}
    - arg:
      - "sleep 300"

#- Refreshing grains
orchestate_sync_grains_init:
  salt.function:
    - name: saltutil.sync_all
    - tgt: {{ id }}

#- Set the hostname
orchestrate_change_hostname:
  salt.function:
    - name: cmd.run
    - tgt: {{ id }}
    - arg:
      - "/usr/bin/hostname {{ short_name }}"
    - onlyif:
      - fun: grains.equals
        key: cloud_fresh_install
        value: True

#- Set the domainname
orchestrate_change_domainname:
  salt.function:
    - name: cmd.run
    - tgt: {{ id }}
    - arg:
      - "/usr/bin/domainname {{ domain_name }}"
    - onlyif:
      - fun: grains.equals
        key: cloud_fresh_install
        value: True

#- Refreshing pillar
orchestate_sync_pillar:
  salt.function:
    - name: saltutil.sync_all
    - tgt: {{ id }}

#- Delete conflicting apt source list
orchestate_delete_apt_source_conflict:
  salt.function:
    - name: cmd.run
    - tgt: {{ id }}
    - arg:
      - "/usr/bin/rm -f /etc/apt/sources.list.d/saltstack.list"
    - onlyif:
      - fun: grains.equals
        key: cloud_fresh_install
        value: True

#- Refreshing grains
orchestate_sync_grains:
  salt.function:
    - name: saltutil.sync_all
    - tgt: {{ id }}
    - onlyif:
      - fun: grains.equals
        key: cloud_fresh_install
        value: True

#- Update the mine
orchestate_update_mine:
  salt.runner:
    - name: mine.update
    - tgt: {{ id }}

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
    - tgt: {{ id }}
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
    - tgt: {{ id }}
    - kwarg:
        key: cloud_fresh_install
        val: False
