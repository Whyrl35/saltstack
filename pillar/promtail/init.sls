#!jinja|yaml|gpg
{% set secret = salt['vault'].read_secret('secret/salt/web/nginx/user') %}
{% set loki_info = salt.http.query('https://api.github.com/repos/grafana/loki/releases/latest')['body'] | load_json %}
{% set version = loki_info.tag_name %}

promtail:
  archive:
    github:
      version: {{ version }}

  config:
    server:
      http_listen_address: 127.0.0.1
      http_listen_port: 19080
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
          instance: {{ grains['id'] }}
          job: systemd-journal
      relabel_configs:
        - source_labels: ['__journal__systemd_unit']
          target_label: 'unit'
    - job_name: syslog
      static_configs:
      - targets:
          - localinstance
        labels:
          instance: {{ grains['id'] }}
          job: syslog
          __path__: /var/log/syslog
    - job_name: messages
      static_configs:
      - targets:
          - localinstance
        labels:
          instance: {{ grains['id'] }}
          job: messages
          __path__: /var/log/messages
    - job_name: kern
      static_configs:
      - targets:
          - localinstance
        labels:
          instance: {{ grains['id'] }}
          job: kern
          __path__: /var/log/kern.log
    - job_name: dpkg
      static_configs:
      - targets:
          - localinstance
        labels:
          instance: {{ grains['id'] }}
          job: dpkg
          __path__: /var/log/dpkg.log
    - job_name: deamon
      static_configs:
      - targets:
          - localinstance
        labels:
          instance: {{ grains['id'] }}
          job: daemon
          __path__: /var/log/daemon.log
    - job_name: auth
      static_configs:
      - targets:
          - localinstance
        labels:
          instance: {{ grains['id'] }}
          job: auth
          __path__: /var/log/auth.log
    - job_name: mail
      static_configs:
      - targets:
          - localinstance
        labels:
          instance: {{ grains['id'] }}
          job: mail
          __path__: /var/log/mail.log
    - job_name: audit
      static_configs:
      - targets:
          - localinstance
        labels:
          instance: {{ grains['id'] }}
          job: audit
          __path__: /var/log/audit/audit.log

### Here are defined per role configuration
{% if 'role' in grains and 'webserver' in grains['role'] %}
    - job_name: nginx
      static_configs:
      - targets:
        - localinstance
        labels:
          job: nginx_access_log
          instance:  {{ grains['id'] }}
          __path__: /var/log/nginx/*.json
{% endif %}
