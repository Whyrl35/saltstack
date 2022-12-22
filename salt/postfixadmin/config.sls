{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import postfixadmin with context %}

postfixadmin_config:
  file.managed:
    - name: {{ postfixadmin.path }}/config.local.php
    - source: salt://postfixadmin/files/config.jinja
    - user: {{ postfixadmin.identity.web.user }}
    - group: {{ postfixadmin.identity.web.group }}
    - mode: "0644"
    - template: jinja
    - context:
      config: {{ postfixadmin.config }} 
    - require:
      - archive: postfixadmin-archive-install

postfixadmin_templates:
  file.directory:
    - name: {{ postfixadmin.path }}/templates_c
    - user: {{ postfixadmin.identity.web.user }}
    - group: {{ postfixadmin.identity.web.group }}
    - mode: "0755"
    - require:
      - archive: postfixadmin-archive-install
