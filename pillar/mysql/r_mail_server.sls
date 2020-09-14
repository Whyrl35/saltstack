#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/databases/mysql') %}

mysql:
  #
  # Databases
  #
  database:
    - name: postfix
      character_set: utf8
      collate: utf8_general_ci
  #
  # Users
  #
  user:
    postfix:
      password: {{ secret['postfix'] }}
      host: localhost
      databases:
        - database: postfix
          grants: ['all privileges']
