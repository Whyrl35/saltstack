filebeat:
  mergeconf:
    output.elasticsearch:
      hosts: ['127.0.0.1:9200']
      indices:
        - index: 'wazuh-alerts-3.x-%{+yyyy.MM.dd}'
