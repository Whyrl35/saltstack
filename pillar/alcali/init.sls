{% set secret = salt['vault'].read_secret('secret/salt/databases/mysql') %}

alcali:
  deploy:
    repository: https://github.com/latenighttales/alcali.git
    branch: develop
    user: alcali
    group: alcali
    directory: /opt/alcali
    service: alcali
    runtime: python3
  gunicorn:
    name: 'config.wsgi:application'
    host: '0.0.0.0'
    port: 8000
    workers: {{ grains['num_cpus'] }}
  # All the items under this section will be converted into an environment file.
  config:
    auth_backend: local
    db_backend: mysql
    db_name: salt
    db_user: alcali
    db_pass: {{ secret['alcali'] }}
    db_host: localhost
    db_port: 3306
    master_minion_id: saltmaster.whyrl.fr
    secret_key: '7jZ7ZNKBp6yVjsHKwsiMZMXvYy8Ji8EDUEzKmNZKdf4cheG5MxFjKkA7kWAv6UB7'
    allowed_hosts: '*'
    salt_url: 'http://localhost:3333'
    salt_auth: alcali
