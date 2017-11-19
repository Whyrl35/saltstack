beamium:
  scrapers:
    noderig:
      url: http://127.0.0.1:9100/metrics
      format: sensision
      period: 30000

  sinks:
    warp10:
      url: https://warp10.ks.whyrl.fr/api/v0/update
      token-header: X-Warp10-Token
      token: 4.tQfZdSO_Ic7gASuPmvO2e3TUpMZgYwK7BMrirCk66aX1uWHUN.CvN7W6ilsZNQoyRo_U7vEysAaF7aiJpk_jywDOetxgwSiTvZLRxtKWtvH.akiCUhNvJMnXqNTj_D
      ttl: 3600

  labels:
    host:         {{ grains['id'] }}

  parameters:
    source-dir:   /opt/beamium/sources
    sink-dir:     /opt/beamium/sinks
    log-file:     /var/log/beamium/beamium.log
    scan-period:  5000
    batch-count:  250
    batch-size:   200000
    timeout:      500
    log-level:    3 # 1: critical / 2: errors / 3: warning / 4: info
