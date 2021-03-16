#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/openstack') %}

{% if grains['deployment'] == 'gra' %}
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
    {% if 'vault' in grains['roles'] %}
      - /opt/vault
    {% endif %}
    {% if 'homeassistant' in grains['roles'] %}
      - /usr/share/hassio
    {% endif %}
    {% if grains['id'] == 'ks001.whyrl.fr' %}
    exclude:
        path:
          - backup
    {% endif %}

