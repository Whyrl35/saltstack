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
          current: 2.8.1
          url: https://api.github.com/repos/senx/warp10-platform/releases/latest
