include:
  - webhook.config

webhook_service:
  service.running:
    - name: webhook
    - enable: true
    - require:
      - file: webhook_configuration
    - watch:
      - file: webhook_configuration
