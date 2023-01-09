---
{% set secret = salt['vault'].read_secret('secret/salt/mail/roundcubemail') %}
roundcubemail:
  config:
    others:
      support_url: 'mailto:ludovic@whyrl.fr'
      des_key: '{{ secret['des_key'] }}'
    database:
      type: mysql
      name: roundcubemail
      host: {{ secret['db_host'] }}
      port: {{ secret['db_port'] }}
      user: {{ secret['db_user'] }}
      password: {{ secret['db_password'] }}
    imap:
      enable: true
      host: '{{ secret['imap_host'] }}'
      conn_options:
        ssl:
          verify_peer: 'false'
          verify_depth: 3
          cafile: '/etc/ssl/certs/whyrl.fr.fullchain.pem'
    smtp:
      enable: true
      host: '{{ secret['smtp_host'] }}'
      conn_options:
        ssl:
          verify_peer: 'false'
          verify_depth: 3
          cafile: '/etc/ssl/certs/whyrl.fr.fullchain.pem'
    plugins:
      - acl
      - additional_message_headers
      - archive
      - emoticons
      - managesieve
      - markasjunk
