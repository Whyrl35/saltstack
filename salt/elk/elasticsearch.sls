# ------------------------------------------------------------
# - Installing filebeat
# -
elasticsearch:
  pkg.installed:
    - pkgs:
      - elasticsearch

  service.running:
    - name: elasticsearch
    - enable: True
    - require:
      - cmd: elasticsearch_systemd

  cmd.run:
    - name:
      - curl https://raw.githubusercontent.com/wazuh/wazuh/3.0/extensions/elasticsearch/wazuh-elastic6-template-alerts.json | curl -XPUT 'http://localhost:9200/_template/wazuh' -H 'Content-Type: application/json' -d @-  # noqa: 204
      - curl https://raw.githubusercontent.com/wazuh/wazuh/3.0/extensions/elasticsearch/wazuh-elastic6-template-monitoring.json | curl -XPUT 'http://localhost:9200/_template/wazuh-agent' -H 'Content-Type: application/json' -d @-  # noqa: 204
    - unless: curl -s http://localhost:9200/_template/wazuh | python -m json.tool | grep alerts

elasticsearch_systemd:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - pkg: elasticsearch
