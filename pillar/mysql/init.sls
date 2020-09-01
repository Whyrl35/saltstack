#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/databases/mysql') %}

mysql:
  #
  # Override vars to install mariadb instead of mysql
  #
  lookup:
    server: mariadb-server
    client: mariadb-client
    service: mariadb

  #
  # Global Configuration
  #
  global:
    client-server:
      default_character_set: utf8
    clients:
      mysql:
        default_character_set: utf8
      mysqldump:
        default_character_set: utf8
    library:
      client:
        default_character_set: utf8
  #
  # Server configuration
  #
  server:
    root_password: {{ secret['root'] }}
    mysqld:
      bind-address: 0.0.0.0
      log_bin: /var/log/mysql/mysql-bin.log
      datadir: /var/lib/mysql
      port: 3307

  ################################# MAIL SERVER ###############################

  {% if 'mail_server' in grains['roles'] %}
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
  {% endif %}
