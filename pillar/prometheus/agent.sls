---
prometheus:
  wanted:
    component:
      - node_exporter
      {% if 'dns-master' in salt.grains.get('role', []) %}
      - bind_exporter
      {% endif %}
      {% if 'mailserver' in salt.grains.get('role', []) %}
      - postfix_exporter
      {% endif %}
      {% if 'webserver' in salt.grains.get('role', []) %}
      - nginx_exporter
      {% endif %}

  pkg:
    component:
      nginx_exporter:
        environ_file: /etc/default/prometheus-nginx-exporter
        environ:
          environ_arg_name: 'ARGS'
          args:
            nginx.scrape-uri: "http://127.0.0.1:9180/stub_status"
