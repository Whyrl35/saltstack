#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/domotique/hassio') %}
{% set account = salt['vault'].read_secret('secret/salt/account/homeassistant') %}

homeassistant:
  base_url: hassio.whyrl.fr
  token: {{ secret['token'] }}
  account:
    password: {{ account['password'] }}
