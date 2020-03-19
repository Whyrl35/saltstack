#!jinja|yaml|gpg
{% set host = salt.grains.get('host') %}

include:
    - beamium.common
    - beamium.h_{{ host }}
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - beamium.r_{{ role }}
    {% endfor %}
    {% endif %}

