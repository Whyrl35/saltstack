{% from 'warp10/common.jinja' import defaults %}
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
        - name: warp10
          current: {{ version }}
          url: https://api.github.com/repos/senx/warp10-platform/releases/latest
