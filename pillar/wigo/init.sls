#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/monitoring/wigo') %}
{% from 'hosts-ips.jinja' import ips %}

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
      url: {{ secret['notification_url'] }}
