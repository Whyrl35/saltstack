#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}
{% set shared_secret = salt['vault'].read_secret('secret/saltstack/shared') %}

wigo:
  server:
    ip: 217.182.85.34
  client:
    ips: {{ ips.myhosts.ipv4 }}
  mail:
    enabled: 2
    server: 127.0.0.1:25
    mailto:
      - 'ludovic+wigo@whyrl.fr'
  notification:
    http:
      enabled: 1
      url: {{ shared_secret['wigo_notification_url'] }}

include:
    - wigo.common
