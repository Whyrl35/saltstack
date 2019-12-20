{% set host = salt.grains.get('host') %}

bind:
  lookup:
    pkgs:
      - bind9
    service: bind9
    key_directory: '/etc/bind/keys'
    key_algorithm: RSASHA256
    key_algorithm_field: '008'
    key_size: 4096
    zones_source_dir: bind/zonedata

  config:
    user: root
    group: named
    mode: 640
    enable_logging: false

    options:
      allow-recursion: '{ 192.168.0.0/16; }'
      default_zones: false    # zones from rfc1918
      querylog: 'yes'

include:
  - bind.h_{{ host }}
