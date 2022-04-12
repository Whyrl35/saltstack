{% from 'loki/common.jinja' import defaults %}
{% set version = defaults.version %}

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
          current: {{ version }}
          url: https://api.github.com/repos/grafana/loki/releases/latest
        - name: promtail
          current: {{ version }}
          url: https://api.github.com/repos/grafana/loki/releases/latest
