#!jinja|yaml|gpg

{% if ('roles' in grains) and ('webserver' in grains['roles']) %}
include:
  - nginx.{{ salt.grains.get('host') }}
{% endif %}
