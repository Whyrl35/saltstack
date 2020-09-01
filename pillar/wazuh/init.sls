#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/siem/wazuh') %}

wazuh:
  server: 217.182.85.34
  auth:
    passwd: {{ secret['password'] }}
