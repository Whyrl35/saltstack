#!jinja|yaml|gpg

include:
  - nginx.{{ salt.grains.get('host') }}
