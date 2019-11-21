{% from 'borgwrapper/map.jinja' import borgwrapper with context %}

include:
  - systemctl.daemon-reload

{% for name, params in borgwrapper.configs.items() %}
{% set config = borgwrapper.config_defaults %}
{% do config.update(params) %}
{% set config_file = [borgwrapper.config_dir, name] | join('/') %}

borgwrapper_{{ name }}_config:
  file.managed:
    - name: {{ config_file }}
    - source: salt://borgwrapper/files/config
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - context:
        config: {{ config|tojson }}

borgwrapper_{{ name }}_backup_service:
  file.managed:
    - name: /etc/systemd/system/borgwrapper-backup@.service
    - source: salt://borgwrapper/files/borgwrapper-backup@.service
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - cmd: daemon-reload

borgwrapper_{{ name }}_backup_timer:
  file.managed:
    - name: /etc/systemd/system/borgwrapper-backup@.timer
    - source: salt://borgwrapper/files/borgwrapper-backup@.timer
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - cmd: daemon-reload
    - context:
        config: {{ config|tojson }}
  service.running:
    - name: borgwrapper-backup@{{ name }}.timer
    - enable: True
    - require:
      - file: borgwrapper_{{ name }}_backup_service
      - file: borgwrapper_{{ name }}_backup_timer

borgwrapper_{{ name }}_verify_service:
  file.managed:
    - name: /etc/systemd/system/borgwrapper-verify@.service
    - source: salt://borgwrapper/files/borgwrapper-verify@.service
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - cmd: daemon-reload

borgwrapper_{{ name }}_verify_timer:
  file.managed:
    - name: /etc/systemd/system/borgwrapper-verify@.timer
    - source: salt://borgwrapper/files/borgwrapper-verify@.timer
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - cmd: daemon-reload
    - context:
        config: {{ config|tojson }}
  service.running:
    - name: borgwrapper-verify@{{ name }}.timer
    - enable: True
    - require:
      - file: borgwrapper_{{ name }}_verify_service
      - file: borgwrapper_{{ name }}_verify_timer

{% endfor %}
