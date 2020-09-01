#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/domotique/hassio') %}

homeassistant:
  base_url: hassio.whyrl.fr
  token: {{ secret['token'] }}
