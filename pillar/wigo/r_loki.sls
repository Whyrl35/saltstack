wigo:
  probes:
    check_version: true
  probes_actives:
    check_version: 300
  probes_config:
    check_version:
      enabled: 'true'
      versionList:
        - name: loki
          current: '2.2.1'
          url: https://api.github.com/repos/grafana/loki/releases/latest
        - name: promtail
          current: '2.2.1'
          url: https://api.github.com/repos/grafana/loki/releases/latest
