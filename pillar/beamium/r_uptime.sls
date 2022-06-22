#!jinja|yaml|gpg
{% set secret = salt['vault'].read_secret('secret/salt/uptime') %}

beamium:
  scrapers:
    uptime-kuma:
      url: https://uptime.whyrl.fr/metrics
      period: 30s
      format: prometheus
      labels:
        host: {{ grains['id'] }}
        job: uptime
      headers:
        Authorization: Basic {{ secret['basic_auth'] }}
