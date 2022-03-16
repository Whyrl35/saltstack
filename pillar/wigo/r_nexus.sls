{% set secret = salt['vault'].read_secret('secret/salt/nexus/users') %}

wigo:
  probes:
    check_version: true
    nexus: true
  probes_actives:
    check_version: 300
    nexus: 300
  probes_config:
    check_version:
      enabled: 'true'
      versionList:
        - name: nexus
          current: '3.38.0'
          url: https://api.github.com/repos/sonatype/nexus-public/releases/latest
    nexus:
      enabled: 'true'
      user: 'nx-monitor'
      password: {{ secret['nx-monitor'] }}
