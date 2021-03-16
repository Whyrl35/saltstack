# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import restic with context %}

# config file in etc
restic-configuration-directory:
  file.directory:
    - name: {{ restic.configuration.path }}
    - user: root
    - group: root
    - dir_mode: '0700'
    - file_mode: '0600'
    - recurse:
      - user
      - group
      - mode

restic-configuration-file:
  file.managed:
    - name: {{ restic.configuration.path }}/restic.sh
    - source: salt://{{ tplroot }}/files/restic.sh.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0600"
    - context:
        restic: {{ restic|tojson }}
    - require:
      - file: restic-configuration-directory

# init the repository and create a file (to make it happen only once) /etc/restic/.init
restic-repository-init:
  cmd.run:
    - name: ". {{ restic.configuration.path }}/restic.sh ; restic -r ${RESTIC_PATH} init && touch {{ restic.configuration.path }}/.init"
    - creates: {{ restic.configuration.path }}/.init
    - require:
      - file: restic-configuration-file

# deploy execution script
restic-backup-script:
  file.managed:
    - name: {{ restic.binary.path }}/{{ restic.name }}-backup-script
    - source: salt://{{ tplroot }}/files/restic-backup-script.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0755"
    - context:
        restic: {{ restic|tojson }}
    - require:
      - file: restic-configuration-directory

# deploy a script to purge the backup
restic-purge-script:
  file.managed:
    - name: {{ restic.binary.path }}/{{ restic.name }}-purge-script
    - source: salt://{{ tplroot }}/files/restic-purge-script.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0755"
    - context:
        restic: {{ restic|tojson }}
    - require:
      - file: restic-configuration-directory
