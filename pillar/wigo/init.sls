#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}
{% set host = salt.grains.get('host') %}

wigo:
  server:
    ip: 217.182.85.34
  client:
    ips: {{ ips.myhosts.ipv4 }}
  mail:
    enabled: 2
    server: 127.0.0.1:25
    mailto:
      - 'ludovic+wigo@whyrl.fr'

include:
    - wigo.common
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - wigo.r_{{ role }}
    {% endfor %}
    {% endif %}
    - wigo.h_{{ host }}
