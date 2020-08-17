{% set roles = salt.grains.get('roles', []) %}

noderig:
  probes:
    lm-sensors: 30
