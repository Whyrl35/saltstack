#!jinja|yaml|gpg

{% set shared_secret = salt['vault'].read_secret('secret/saltstack/shared') %}

account_name: ludovic
account_fullname: {{ shared_secret['account_fullname'] }}
account_password: {{ shared_secret['account_password'] }}
