# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import restic with context %}

# service that launch the backup scrit in oneshot
restic-backup-prerequisit-service:
  file.managed:
    - name: /etc/systemd/system/{{ restic.name }}-backup.service
    - source: salt://restic/files/restic-backup.systemd.jinja
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - defaults:
        restic: {{ restic }}
    - require:
      - file: restic-backup-script

# systemd timer that launch the above service
restic-backup-timer:
  file.managed:
    - name: /etc/systemd/system/{{ restic.name }}-backup.timer
    - source: salt://restic/files/restic-backup.timer.jinja
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - defaults:
        restic: {{ restic }}
    - require:
      - file: restic-backup-prerequisit-service
  service.running:
    - name: {{ restic.name }}-backup.timer
    - enable: true
    - require:
      - file: restic-backup-timer

# service that that purge the backup via a script (to be created)
restic-purge-prerequisit-service:
  file.managed:
    - name: /etc/systemd/system/{{ restic.name }}-purge.service
    - source: salt://restic/files/restic-purge.systemd.jinja
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - defaults:
        restic: {{ restic }}
    - require:
      - file: restic-backup-prerequisit-service
      - file: restic-purge-script

# systemd timer that once a day launch the purge script (--forget) 6-daily/4-weekly/2-monthly/1-yearly
restic-purge-timer:
  file.managed:
    - name: /etc/systemd/system/{{ restic.name }}-purge.timer
    - source: salt://restic/files/restic-purge.timer.jinja
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - defaults:
        restic: {{ restic }}
    - require:
      - file: restic-backup-prerequisit-service
  service.running:
    - name: {{ restic.name }}-purge.timer
    - enable: true
    - require:
      - file: restic-purge-timer

# refresh systemd when there is change on above files
restic-refresh-systemd:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: restic-backup-prerequisit-service
      - file: restic-purge-prerequisit-service
      - file: restic-backup-timer
      - file: restic-purge-timer
