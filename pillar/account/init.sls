#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/account/ludovic') %}

account_name: ludovic
account_fullname: {{ secret['fullname'] }}
account_password: {{ secret['password'] }}
