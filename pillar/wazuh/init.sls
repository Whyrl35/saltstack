#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/siem/wazuh') %}
{% set users = salt['vault'].read_secret('secret/salt/siem/wazuh/users') %}

wazuh:
  server: 217.182.85.34
  auth:
    passwd: {{ secret['password'] }}
  users:
    {% for k,v in users.items() %}
    {{ k }}:
      password: {{ v }}
    {% endfor %}
