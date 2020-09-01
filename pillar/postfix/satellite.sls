#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/mail/postfix_satellite') %}

include:
  - postfix

postfix_satellite:
  user: robot
  password: {{ secret['password'] }}
