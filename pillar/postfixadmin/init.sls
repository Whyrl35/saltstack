{% set secret_db = salt['vault'].read_secret('secret/salt/databases/mysql') %}
{% set secret_pa = salt['vault'].read_secret('secret/salt/mail/postfixadmin') %}

postfixadmin:
  config:
    database_host: mysql-caaca600-o37d65b73.database.cloud.ovh.net:20184
    database_password: {{ secret_db['postfix'] }}
    setup_password: {{ secret_pa['setup_passwd'] }}
