include:
  - webhook.package

webhook_configuration:
  file.managed:
    - name: /etc/webhook.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://webhook/files/webhook.jinja
    - template: jinja
    - require:
      - pkg : webhook_package