# ------------------------------------------------------------
# - Installing filebeat
# -
filebeat:
  pkg.installed:
    - pkgs:
      - filebeat

  file.managed:
    - name: /etc/filebeat/filebeat.yml
    - source: salt://elk/filebeat.yml
    - user: root
    - group: root
    - mode: 700
    - template: jinja
    - require:
      - pkg : filebeat

  service.running:
    - name: filebeat
    - enable: True
    - require:
      - pkg : filebeat
      - file : /etc/filebeat/filebeat.yml
    - watch:
      - file: /etc/filebeat/filebeat.yml

