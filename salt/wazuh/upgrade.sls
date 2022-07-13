{% set pkg_upgrades = salt['pkg.list_upgrades']() %}
{% set user = 'admin' %}
{% set password = pillar['wazuh']['users'][user]['password'] %}

{% if 'wazuh-indexer' in pkg_upgrades %}
disbale-shard-allocation:
  cmd.run:
    - name: |
        curl -X PUT "https://127.0.0.1:9200/_cluster/settings"  -u {{ user }}:{{ password }} -k -H 'Content-Type: application/json' -d '{ "persistent": { "cluster.routing.allocation.enable": "primaries" }}'

stop-indexing-and-synced:
  cmd.run:
    - name: |
        curl -X POST "https://127.0.0.1:9200/_flush/synced" -u {{ user}}:{{ password }} -k
    - require:
      - cmd: disbale-shard-allocation

stop-wazuh-indexer-service:
  service.dead:
    - name: wazuh-indexer
    - init_delay: 10
    - require:
      - cmd: stop-indexing-and-synced

upgrade-wazuh-indexer-to-latest:
  pkg.latest:
    - name: wazuh-indexer
    - require:
      - service: stop-wazuh-indexer-service

start-wazuh-indexer-service:
  service.running:
    - name: wazuh-indexer
    - enable: true

enable-shard-allocation:
  cmd.run:
    - name: |
        curl -X PUT "https://127.0.0.1:9200/_cluster/settings"  -u {{ user }}:{{ password }} -k -H 'Content-Type: application/json' -d '{ "persistent": { "cluster.routing.allocation.enable": "all" }}'
{% endif %}


{% if 'wazuh-manager' in pkg_upgrades %}
stop-filebeat-service:
  service.dead:
    - name: filebeat
    - init_delay: 10

upgrade-wazuh-manager-to-latest:
  pkg.latest:
    - name: wazuh-manager

start-filebeat-service:
  service.running:
    - name: filebeat
    - enable: true
{% endif %}

{% if 'wazuh-dashboard' in pkg_upgrades %}
stop-wazuh-dashboard-service:
  service.dead:
    - name: wazuh-dashboard
    - init_delay: 10

upgrade-wazuh-dashboard-to-latest:
  pkg.latest:
    - name: wazuh-dashboard

start-wazuh-dashboard-service:
  service.running:
    - name: wazuh-dashboard
    - enable: true
{% endif %}
