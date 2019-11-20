{% from 'borgbackup/map.jinja' import borgbackup with context %}

borgbackup:
  pkg.installed:
    - name: {{ borgbackup.borgbackup }}
