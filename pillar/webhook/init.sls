{% set host = salt.grains.get('host') %}

include:
    - webhook.h_{{ host }}
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - webhook.r_{{ role }}
    {% endfor %}
    {% endif %}
