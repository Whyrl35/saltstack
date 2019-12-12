wigo_config:
  file.managed:
    - name : /etc/wigo/wigo.conf
    - source: salt://wigo/wigo.jinja
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - require:
      - pkg : wigo_package
