#!jinja|yaml|gpg

{% if 'roles' in grains %}
{% set standalone = grains['roles'] | intersect(['webserver', 'mail_server']) %}
{% else %}
{% set standalone = None %}
{% endif %}

{# if ('roles' in grains) and (('webserver' in grains['roles']) or ('mail_server' in grains['roles'])) #}
{% if standalone and (standalone|length > 0 )%}
include:
  - nginx.{{ salt.grains.get('host') }}
{% elif ('roles' in grains) and ('webserver-back' in grains['roles']) %}
include:
  - nginx.webserver-back
{% endif %}
