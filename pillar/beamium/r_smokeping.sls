#!jinja|yaml|gpg

beamium:
  scrapers:
    telegraf:
      url: http://127.0.0.1:9283/metrics
      period: 30s
      format: prometheus
      labels:
        host: {{ grains['id'] }}
        job: probe
