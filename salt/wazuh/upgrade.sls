{% set pkg_upgrades = salt['pkg.list_upgrades']() %}
{% set user = 'admin' %}
{% set password = pillar['wazuh']['users'][user]['password'] %}

{% if 'wazuh-manager' in pkg_upgrades %}
upgrade-wazuh-to-latest:
  pkg.latest:
    - name: wazuh-manager
{% endif %}

{% if ('elasticsearch-oss' in pkg_upgrades) or ('opendistroforelasticsearch-kibana' in pkg_upgrades)  or ('filebeat' in pkg_upgrades) %}
filebeat-stop-service:
  service.dead:
    - name: filebeat

kibana-stop-service:
  service.dead:
    - name: kibana

elastic-disable-shard-allocation:
  cmd.run:
    - name: |
        curl -X PUT "https://127.0.0.1:9200/_cluster/settings" \
          -u {{ user }}:{{ password }} -k -H 'Content-Type: application/json' \
          -d '{ "persistent": { "cluster.routing.allocation.enable": "primaries" } } '
    - require:
      - service: kibana-stop-service
      - service: filebeat-stop-service

elastic-stop-indexing-sync-flush:
  cmd.run:
    - name: curl -X POST "https://127.0.0.1:9200/_flush/synced" -u {{ username }}:{{ password }} -k
    - require:
      - cmd: elastic-disable-shard-allocation

elastic-stop-service:
  service.dead:
    - name: elasticsearch
    - require:
      - cmd: elastic-stop-indexing-sync-flush

elastic-upgrade-to-latest:
  pkg.latest:
    - name: elasticsearch-oss
    - require:
      - service: elastic-stop-service

elastic-start-service:
  service.running:
    - name: elasticsearch
    - enable: True
    - init_delay: 30
    - require:
      - pkg: elastic-upgrade-to-latest

elastic-reenable-shard-allocation:
  cmd.run:
    - name: |
        curl -X PUT "https://127.0.0.1:9200/_cluster/settings" -u {{ user }}:{{ password }} -k \
          -H 'Content-Type: application/json' \
          -d ' { "persistent": { "cluster.routing.allocation.enable": "all" } } '
    - require:
      - service: elastic-start-service

filebeat-upgrade-to-latest:
  pkg.latest:
    - name: filebeat
    - require:
      - cmd: elastic-reenable-shard-allocation

filebeat-alerts-template:
  cmd.run:
    - name: |
        curl -so /etc/filebeat/wazuh-template.json \
        https://raw.githubusercontent.com/wazuh/wazuh/v4.0.4/extensions/elasticsearch/7.x/wazuh-template.json && \
        chmod go+r /etc/filebeat/wazuh-template.json
    - require:
      - pkg: filebeat-upgrade-to-latest

filebeat-latest-module:
  cmd.run:
    - name: curl -s https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.1.tar.gz | sudo tar -xvz -C /usr/share/filebeat/module
    - require:
      - cmd: filebeat-alerts-template

filebeat-change-configuration:
  file.serialize:
    - name: /etc/filebeat/filebeat.yml
    - dataset_pillar: wazuh:filebeat:configuration
    - formatter: yaml
    - merge_if_exists: true
    - require:
      - cmd: filebeat-upgrade-to-latest

filebeat-start-service:
  service.running:
    - name: filebeat
    - enable: True
    - require:
      - cmd: filebeat-change-configuration

kibana-remove-plugin:
  cmd.run:
    - name: /usr/share/kibana/bin/kibana-plugin remove wazuh
    - cwd: /usr/share/kibana
    - runas: kibana
    - require:
      - service: filebeat-start-service

kibana-upgrade-to-latest:
  pkg.latest:
    - name: opendistroforelasticsearch-kibana
    - require:
      - cmd: kibana-remove-plugin

kibana-remove-bundles:
  cmd.run:
    - name: rm -rf /usr/share/kibana/optimize/bundles
    - require:
      - pkg: kibana-upgrade-to-latest

kibana-remove-registry:
  cmd.run:
    - name: rm -f /usr/share/kibana/optimize/wazuh/config/wazuh-registry.json
    - require:
      - pkg: kibana-upgrade-to-latest

kibana-optimize-dir-ownership:
  file.directory:
    - name: /usr/share/kibana/optimize
    - user: kibana
    - group: kibana
    - recurse:
      - user
      - group
    - require:
      - cmd: kibana-remove-bundles

kibana-plugins-dir-ownership:
  file.directory:
    - name: /usr/share/kibana/plugins
    - user: kibana
    - group: kibana
    - recurse:
      - user
      - group
    - require:
      - cmd: kibana-remove-bundles

{% set wazuh_version = salt['pkg.version']("wazuh-manager")[:-2] %}
{% set kibana_version = salt['cmd.shell']('cat /usr/share/kibana/package.json | jq .version | xargs') %}

kibana-install-plugins:
  cmd.run:
    - name: /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/4.x/ui/kibana/wazuh_kibana-{{ wazuh_version }}_{{ kibana_version}}-1.zip
    - cwd: /usr/share/kibana
    - runas: kibana
    - require:
      - file: kibana-optimize-dir-ownership
      - file: kibana-plugins-dir-ownership

kibana-ensure-wazuh-yml:
  file.managed:
    - name: /usr/share/kibana/optimize/wazuh/config/wazuh.yml
    - user: kibana
    - group: kibana
    - mode: '0600'
    - require:
      - cmd: kibana-install-plugins

kibana-default-etc:
  file.managed:
    - name: /etc/default/kibana
    - contents:
      - NODE_OPTIONS="--max_old_space_size=2048"
    - require:
      - file: kibana-ensure-wazuh-yml

kibana-setcap:
  cmd.run:
    - name: setcap 'cap_net_bind_service=+ep' /usr/share/kibana/node/bin/node
    - require:
      - file: kibana-default-etc

kibana-start-service:
  service.running:
    - name: kibana
    - enable: True
    - require:
      - cmd: kibana-setcap

hold-all-packages:
  pkg.installed:
    - pkgs:
      - filebeat
      - opendistroforelasticsearch-kibana
      - elasticsearch-oss
    - hold: True
{% endif %}



