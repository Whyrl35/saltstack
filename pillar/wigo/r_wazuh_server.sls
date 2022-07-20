{% set secret = salt['vault'].read_secret('secret/salt/siem/wazuh/users') %}

wigo:
  extra:
    pip:
      - opensearch-py
  probes:
    elasticsearch: true
  probes_actives:
    elasticsearch: 120
  probes_config:
    elasticsearch:
      enabled: 'true'
      host: 'localhost'
      port: 9200
      username: admin
      use_ssl: 'true'
      password: {{ secret['admin'] }}
      ca_certs_path: '/etc/wazuh-indexer/certs/root-ca.pem'
