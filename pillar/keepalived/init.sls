{% set host = salt.grains.get('host') %}

include:
    {#- .h_{{ host }} #}
    {%- if 'roles' in grains %}
    {%- for role in grains['roles'] %}
    - .r_{{ role }}
    {%- endfor %}
    {%- endif %}
