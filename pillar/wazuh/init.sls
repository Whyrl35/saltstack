#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}
{% set agent = salt['vault'].read_secret('secret/salt/siem/wazuh/agent') %}
{% set users = salt['vault'].read_secret('secret/salt/siem/wazuh/users') %}
{% set slack = salt['vault'].read_secret('secret/salt/siem/wazuh/slack') %}

wazuh:
  server: {% if grains['deployment'] in ['sadc', 'rbx'] %}217.182.85.34{% else %}10.3.80.3{% endif %}
  auth:
    passwd: {{ agent['secret'] }}
  users:
    {% for k,v in users.items() %}
    {{ k }}:
      password: {{ v }}
    {% endfor %}

  kibana:
    configuration:
      output.elasticsearch:
        username: "admin"
        password: "{{ users['admin'] }}"

  ossec:
    configuration:
      ossec_config:
        global:
          email_notification: 'yes'
          smtp_server: localhost
          email_from: wazuh@whyrl.fr
          email_to: ludovic@whyrl.fr
          email_maxperhour: 12
          queue_size: 131072
          {% set allips = ips.myhosts.ipv4 + ips.myhosts.ipv6 %}
          white_list: {{ allips }}
        integration:
          - name: slack
            hook_url: {{ slack['url'] }}
            alert_format: json
            level: 10
        command:
          - name: nftables-blacklist
            executable: nftables-blacklist.py
            timeout_allowed: 'yes'
        active_response:
          - disabled: 'no'
            command: nftables-blacklist
            location: all
            level: 10
            timeout: 300
            repeated_offenders: 15,30,45
          - disabled: 'no'
            command: nftables-blacklist
            location: server
            level: 10
            timeout: 300
            repeated_offenders: 15,30,45
