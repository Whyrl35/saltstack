#!jinja|yaml|gpg
{% set database_secret = salt['vault'].read_secret('secret/salt/databases/mysql') %}

polemarch:
  configuration:
    database:
      engine: django.db.backends.mysql
      name: polemarch
      user: polemarch
      password: {{ database_secret['polemarch'] }}
      host: mysql-caaca600-o37d65b73.database.cloud.ovh.net
      port: 20184
    database.options:
      connect_timeout: 20
      init_command: >-
        SET sql_mode='STRICT_TRANS_TABLES',
        default_storage_engine=INNODB,
        NAMES 'utf8',
        CHARACTER SET 'utf8',
        SESSION collation_connection = 'utf8_unicode_ci'
    cache:
      backend: django.core.cache.backends.redis.RedisCache
      location: redis://127.0.0.1:6379/1
    locks:
      backend: django.core.cache.backends.redis.RedisCache
      location: redis://127.0.0.1:6379/2
    rpc:
      connection: redis://127.0.0.1:6379/3
      heartbeat: 5
      concurrency: 8
      enable_worker: true
    uwsgi:
      pidfile: /opt/polemarch/pid/polemarch.pid
      log_file: /opt/polemarch/log/polemarch_web.log
