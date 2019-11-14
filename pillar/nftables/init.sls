{% set host = salt.grains.get('host') %}

nftables:
  lookup:
    service:
      enable: true
    config: /etc/nftables.conf

include:
    - nftables.common
    - nftables.h_{{ host }}
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - nftables.r_{{ role }}
    {% endfor %}
    {% endif %}
