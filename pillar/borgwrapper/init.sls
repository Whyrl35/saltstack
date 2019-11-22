{% set host = salt.grains.get('host') %}

include:
  - borgwrapper.common
  - borgwrapper.h_{{ host }}
  {% if 'roles' in grains %}
  {% for role in grains['roles'] %}
  - borgwrapper.r_{{ role }}
  {% endfor %}
  {% endif %}
