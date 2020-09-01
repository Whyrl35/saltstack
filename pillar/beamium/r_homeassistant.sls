#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/metrics/beamium/prometheus') %}

beamium:
  scrapers:
    homeassistant:
      url: http://127.0.0.1:8123/api/prometheus
      period: 60s
      format: prometheus
      labels:
        host: homeassistant
      headers:
        Authorization: {{ secret['homeassistant_authorization'] }}
