include:
  - webhook.package

webhook_configuration:
  file.managed:
    - name: /etc/webhook.conf
    - user: root
    - group: root
    - mode: "0644"
    - source: salt://webhook/files/webhook.jinja
    - template: jinja
    - require:
      - pkg : webhook_package

{% if 'files' in pillar['webhooks'] %}
webhook_files:
  file.managed:
    - names: {{ pillar['webhooks']['files'] }}
    - user: root
    - group: root
    - mode: "0755"
    - makedirs: True
    - dir_mode: "0755"
{% endif %}
