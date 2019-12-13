hassio_dir:
  file.directory:
    - name: /srv/hassio
    - user: root
    - group: root
    - mode: "0755"

hassio_file:
  file.managed:
    - name: /srv/hassio/hassio_install.sh
    - user: root
    - group: root
    - mode: "0755"
    - source: https://raw.githubusercontent.com/home-assistant/hassio-installer/master/hassio_install.sh
    - source_hash: 2f23c57f6cb4fc97b7cfb9313d861a1a326d693d8b4fcf29b273420411637345

hassio_install:
  cmd.run:
    - name: /srv/hassio/hassio_install.sh
    - creates: /usr/share/hassio/homeassistant.json
    - runas: ludovic

hassio_supervisor_service:
  service.running:
    - name: hassio-supervisor
    - enable: true

# TODO: need to place a the last backup in the good directory in case of a re-install
#       and that a restore is needed (borg or nas)

hassio_homeassistant_check_update:
  http.query:
    - name: https://{{ salt.pillar.get('homeassistant:base_url') }}/api/states/binary_sensor.updater
    - match: '"state": "on"'
    - header_list: ["Authorization: Bearer {{ salt.pillar.get('homeassistant:token') }}", 'Content-Type: application/json']
    - header_render: true
    - status: 200
    - raise_error: false

hassio_homeassistant_update:
    http.query:
      - name: https://hassio.whyrl.fr/api/hassio/homeassistant/update
      - method: 'POST'
      - header_list: ["Authorization: Bearer {{ salt.pillar.get('homeassistant:token') }}", 'Content-Type: application/json']
      - header_render: true
      - status: 200
      - raise_error: true
