{% set host = salt.grains.get('host') %}

include:
  - .common
  - .h_{{ host }}
  {% if 'roles' in grains %}
  {% for role in grains['roles'] %}
  - .r_{{ role }}
  {% endfor %}
  {% endif %}