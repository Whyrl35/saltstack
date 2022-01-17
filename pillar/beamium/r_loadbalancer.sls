#!jinja|yaml|gpg

beamium:
  scrapers:
    haproxy:
      url: https://{{ grains['id'] }}:8801/prom-metrics
      period: 10s
      format: prometheus
      labels:
        host: {{ grains['id'] }}
        app: haproxy
