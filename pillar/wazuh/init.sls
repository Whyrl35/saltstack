#!jinja|yaml|gpg

{% set agent = salt['vault'].read_secret('secret/salt/siem/wazuh/agent') %}
{% set users = salt['vault'].read_secret('secret/salt/siem/wazuh/users') %}

wazuh:
  server: 217.182.85.34
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
          email_notification: yes
          smtp_server: localhost
          email_from: wazuh@whyrl.fr
          email_to: ludovic@whyrl.fr
          email_maxperhour: 12
          queue_size: 131072
        integration:
          name: slack
          # TODO: put here the slack url from vault
          alert_format: json
          level: 8
        alerts:
          log_alert_level: 3
          email_alert_level: 12
