#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/databases/mysql') %}

mysql:
  #
  # Databases
  #
  database:
    - name: salt
      character_set: utf8
      collate: utf8_general_ci
  #
  # Users
  #
  user:
    salt:
      password: {{ secret['salt'] }}
      host: localhost
      databases:
        - database: salt
          grants: ['all privileges']
    alcali:
      password: {{ secret['alcali'] }}
      host: localhost
      databases:
        - database: salt
          grants: ['all privileges']
