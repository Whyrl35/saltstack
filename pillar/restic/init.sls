#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/openstack') %}

{% if grains['deployment'][0:3] == 'gra' %}
{% set container_name = 'bkp-repo2' %}
{% set region_name = 'DE' %}
{% else %}
{% set container_name = 'bkp-repo1' %}
{% set region_name = 'GRA' %}
{% endif %}

restic:
  repositories:
    repo1:
      type: swift
      parameters:
        path: /{{ grains['host'] }}
        container_name: {{ container_name }}
      environment:
        OS_AUTH_URL: 'https://auth.cloud.ovh.net/v3'
        OS_REGION_NAME: {{ region_name }}
        OS_USERNAME: {{ secret['username'] }}
        OS_PASSWORD: {{ secret['password'] }}
        OS_USER_DOMAIN_NAME: default
        OS_PROJECT_NAME: {{ secret['project_name'] }}
        OS_PROJECT_ID: {{ secret['project_id'] }}
        OS_PROJECT_DOMAIN_NAME: default

  backup:
    need_status: true
    paths:
      - /srv
      - /etc
    {% if 'homeassistant' in grains['roles'] %}
      - /usr/share/hassio
      - /usr/share/hassio/homeassistant
    exclude:
      path:
        - /usr/share/hassio/media
        - /usr/share/hassio/homeassistant/home-assistant_v2.db
    precommand:
      - /srv/homeassistant/home-assistant_backup.sh
    postcommand:
      - /usr/bin/rm -rf /srv/homeassistant/home-assistant_v2.db.dump
    {% endif %}
    {% if 'vault' in grains['roles'] %}
      - /opt/vault
    {% endif %}
    {% if 'warp10' in grains['roles'] %}
      - /opt/warp10/leveldb/snapshots
    precommand:
      - /usr/bin/rm -rf /opt/warp10/leveldb/snapshots/warp10-backup
      - /opt/warp10/bin/warp10-standalone.init snapshot 'warp10-backup'
      - /usr/bin/sqlite3 /var/lib/grafana/grafana.db '.backup /srv/grafana-backup/grafana.db'
    postcommand:
      - /usr/bin/rm -rf /opt/warp10/leveldb/snapshots/warp10-backup
    {% endif %}
    {% if 'swarm' in grains['roles'] %}
      - /var/lib/docker/volumes/
    {% endif %}
    {% if grains['id'] == 'ks001.whyrl.fr' %}
    exclude:
        path:
          - backup
    {% endif %}
