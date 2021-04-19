#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/web/nginx/user') %}

promtail:
  archive:
    github:
      version: '2.2.1'

  config:
    clients:
    - url: https://loki.whyrl.fr/loki/api/v1/push
      basic_auth:
        username: loki
        password: {{ secret['loki'] }}
    scrape_configs:
    - job_name: journal
      journal:
        json: false
        max_age: 12h
        path: /run/log/journal
        labels:
          host: {{ grains.get('id') }}
          job: systemd-journal
      relabel_configs:
        - source_labels: ['__journal__systemd_unit']
          target_label: 'unit'
    - job_name: syslog
      static_configs:
      - targets:
          - localhost
        labels:
          host: {{ grains.get('id') }}
          job: syslog
          __path__: /var/log/syslog
    - job_name: messages
      static_configs:
      - targets:
          - localhost
        labels:
          host: {{ grains.get('id') }}
          job: messages
          __path__: /var/log/messages
    - job_name: kern
      static_configs:
      - targets:
          - localhost
        labels:
          host: {{ grains.get('id') }}
          job: kern
          __path__: /var/log/kern.log
    - job_name: dpkg
      static_configs:
      - targets:
          - localhost
        labels:
          host: {{ grains.get('id') }}
          job: dpkg
          __path__: /var/log/dpkg.log
    - job_name: deamon
      static_configs:
      - targets:
          - localhost
        labels:
          host: {{ grains.get('id') }}
          job: daemon
          __path__: /var/log/daemon.log
    - job_name: auth
      static_configs:
      - targets:
          - localhost
        labels:
          host: {{ grains.get('id') }}
          job: auth
          __path__: /var/log/auth.log

    - job_name: mail
      static_configs:
      - targets:
          - localhost
        labels:
          host: {{ grains.get('id') }}
          job: mail
          __path__: /var/log/mail.log
    - job_name: wigo
      static_configs:
      - targets:
          - localhost
        labels:
          host: {{ grains.get('id') }}
          job: wigo
          __path__: /var/log/wigo.log

### Here are defined per role configuration
{% if 'roles' in grains and 'webserver' in grains['roles'] %}
    - job_name: nginx
      static_configs:
      - targets:
        - localhost
        labels:
          job: nginx_access_log
          host:  {{ grains.get('id') }}
          __path__: /var/log/nginx/*.json
{% endif %}

{% if 'roles' in grains and 'mail_server' in grains['roles'] %}
    - job_name: nginx
      static_configs:
      - targets:
        - localhost
        labels:
          job: nginx_access_log
          host:  {{ grains.get('id') }}
          __path__: /var/log/nginx/*.json
{% endif %}
