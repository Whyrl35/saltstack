{% set host = salt.grains.get('host', []) %}

noderig:
  probes:
    {% if host and ('srv002' in host or 'ks' in host) %}
    lm-sensors: 30
    {% else %}
    {}
    {% endif %}
