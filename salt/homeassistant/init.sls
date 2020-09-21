hassio_dir:
  file.directory:
    - name: /srv/hassio
    - user: root
    - group: root
    - mode: "0755"

hassio_package:
  pkg.installed:
    - pkgs:
      - python3-venv
      - python3-pip

hassio_pip:
  pip.installed:
    - name: pipx
    - require:
      - pkg: hassio_package

create_account_name:
  user.present:
    - name: homeassistant
    - home: /srv/homeassistant
    - password: {{ pillar['homeassistant']['account']['password'] }}
    - hash_password: True
    - enforce_password: True
    - usergroup: True
    - mindays: 0
    - maxdays: 99999
    - inactdays: -1
    - warndays:
    - expire: -1
    - system: True
    - allow_uid_change: True
    - allow_gid_change: True
    - shell: /usr/bin/zsh
    - require:
      - pkg : zsh
