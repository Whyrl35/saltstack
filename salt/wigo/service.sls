wigo_service:
  service.running:
    - name: wigo
    - enable: True
    - require:
      - pkg : wigo_package
      - file : wigo_config
    - watch:
      - file : wigo_config