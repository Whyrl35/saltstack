#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/monitoring/wigo') %}
{% from 'hosts-ips.jinja' import ips %}

wigo:
  server:
    ip: 217.182.85.34
  client:
    ips: {{ ips.myhosts.ipv4 }}
  notification:
    min_level_to_send: 250
    rescue_only: 'true'
    on_wigo_change: 'true'
    on_probe_change: 'true'
    http:
      enabled: 1
      url: {{ secret['notification_url'] }} # here call the local webhook url
    mail:
      enabled: 2
      server: 127.0.0.1:25
      mailto:
        - 'ludovic+wigo@whyrl.fr'
