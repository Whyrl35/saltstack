wigo_service:
  service.running:
    - name: wigo
    - enable: True
    - require:
      - pkg : wigo
      - file : /etc/wigo/wigo.conf
    - watch:
      - file : /etc/wigo/wigo.conf