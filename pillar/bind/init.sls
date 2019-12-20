{% set host = salt.grains.get('host') %}

bind:
  config:
    options:
      allow-recursion: '{ 192.168.0.0/16; }'
      default_zones: false    # zones from rfc1918
      querylog: 'yes'

include:
  - bind.h_{{ host }}
