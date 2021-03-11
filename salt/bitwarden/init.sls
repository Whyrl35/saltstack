bitwarden_dir:
  file.directory:
    - name: /srv/bitwarden
    - user: ludovic
    - group: users
    - mode: "0755"

bitwarden_file:
  file.managed:
    - name: /srv/bitwarden/bitwarden.sh
    - user: ludovic
    - group: users
    - mode: "0755"
    - source: https://raw.githubusercontent.com/bitwarden/server/master/scripts/bitwarden.sh
    - source_hash: f22283c6e635b8b7d4a0c97af5d9f18d92bb6169d8c7f9334f01b21da15e77d8

bitwarden_config:
  file.managed:
    - name: /srv/bitwarden/bwdata/config.yml
    - makedirs: true
    - dir_mode: "0755"
    - user: ludovic
    - group: users
    - mode: "0644"
    - source: salt://bitwarden/files/config.yml
    - require:
      - file: bitwarden_file

bitwarden_override_global:
  file.managed:
    - name: /srv/bitwarden/bwdata/env/global.override.env
    - makedirs: true
    - dir_mode: "0755"
    - user: ludovic
    - group: users
    - mode: "0644"
    - template: jinja
    - source: salt://bitwarden/files/global.override.env
    - require:
      - file: bitwarden_file
      - file: bitwarden_config

bitwarden_override_mssql:
  file.managed:
    - name: /srv/bitwarden/bwdata/env/mssql.override.env
    - makedirs: true
    - dir_mode: "0755"
    - user: ludovic
    - group: users
    - mode: "0644"
    - template: jinja
    - source: salt://bitwarden/files/mssql.override.env
    - require:
      - file: bitwarden_file
      - file: bitwarden_config

bitwarden_override_uid:
  file.managed:
    - name: /srv/bitwarden/bwdata/env/uid.override.env
    - makedirs: true
    - dir_mode: "0755"
    - user: ludovic
    - group: users
    - mode: "0644"
    - source: salt://bitwarden/files/uid.override.env
    - require:
      - file: bitwarden_file
      - file: bitwarden_config

bitwarden_install:
  cmd.run:
    - name: /srv/bitwarden/bitwarden.sh install
    - creates: /srv/bitwarden/bwdata/docker/global.env
    - runas: ludovic
    - require:
      - file: bitwarden_config
      - file: bitwarden_override_global

#bitwarder_update:
#  cmd.run:
#    - name: /srv/bitwarden/bitwarden.sh update
#    - runas: ludovic
#    - onchanges:
#      - file: bitwarden_config
