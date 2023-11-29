{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import polemarch with context %}

polemarch-configuration-file:
  ini.options_present:
    - name: {{ polemarch.path.etc }}/settings.ini
    - separator: '='
    - strict: True
    - sections: {{ polemarch.configuration }}

polemarch-migrate:
  cmd.run:
    - name: /opt/polemarch/bin/polemarchctl migrate
    - unless: /opt/polemarch/bin/polemarchctl migrate --check
