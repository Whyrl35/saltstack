prometheus:
  pkg:
    component:
      prometheus:
        config:
          global:
            external_labels:
              # Attach these labels to any time series or alerts when communicating with
              # external systems (federation, remote storage, Alertmanager).
              monitor: 'whyrl'
            scrape_interval:     15s  # Set the scrape interval to every 15 seconds. Default is every 1 minute.
            evaluation_interval: 15s  # Evaluate rules every 15 seconds. The default is every 1 minute.
                                      # scrape_timeout is set to the global default (10s).
          alerting:
            alertmanagers:
            - static_configs:
              - targets: ['localhost:9093']

          rule_files:

          # A scrape configuration containing exactly one endpoint to scrape:
          # Here it's Prometheus itself.
          scrape_configs:
          # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
            - job_name: 'prometheus'
              # Override the global default and scrape targets from this job every 5 seconds.
              scrape_interval: 5s
              scrape_timeout: 5s
              # metrics_path defaults to '/metrics'
              # scheme defaults to 'http'.
              static_configs:
                - targets: ['prometheus.cloud.whyrl.fr:9090']

            - job_name: node
              # If prometheus-node-exporter is installed, grab stats about the local
              # machine by default.
              static_configs:
              - targets:
                {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='*', fun='network.ip_addrs').items() %}
                - {{ fqdn }}:9100
                {% endfor %}
              relabel_configs:
                - source_labels: ['__address__']
                  separator:     ':'
                  regex:         '(.*):.*'
                  target_label:  'instance'
                  replacement:   '${1}'

            - job_name: docker
              static_configs:
              - targets:
                {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='role:container', fun='network.ip_addrs', tgt_type='grain').items() %}
                - {{ fqdn }}:9101
                {% endfor %}
              relabel_configs:
                - source_labels: ['__address__']
                  separator:     ':'
                  regex:         '(.*):.*'
                  target_label:  'instance'
                  replacement:   '${1}'

            - job_name: docker-cadvisor
              static_configs:
              - targets:
                {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='role:container', fun='network.ip_addrs', tgt_type='grain').items() %}
                - {{ fqdn }}:9102
                {% endfor %}
              relabel_configs:
                - source_labels: ['__address__']
                  separator:     ':'
                  regex:         '(.*):.*'
                  target_label:  'instance'
                  replacement:   '${1}'

            - job_name: haproxy
              scheme: https
              static_configs:
              - targets:
                {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='role:loadbalancer', fun='network.ip_addrs', tgt_type='grain').items() %}
                - {{ fqdn }}:8801
                {% endfor %}
              relabel_configs:
                - source_labels: ['__address__']
                  separator:     ':'
                  regex:         '(.*):.*'
                  target_label:  'instance'
                  replacement:   '${1}'

            - job_name: bind
              static_configs:
              - targets:
                {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='role:dns-master', fun='network.ip_addrs', tgt_type='grain').items() %}
                - {{ fqdn }}:9119
                {% endfor %}
              relabel_configs:
                - source_labels: ['__address__']
                  separator:     ':'
                  regex:         '(.*):.*'
                  target_label:  'instance'
                  replacement:   '${1}'

            - job_name: postfix
              static_configs:
              - targets:
                {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='role:mailserver', fun='network.ip_addrs', tgt_type='grain').items() %}
                - {{ fqdn }}:9154
                {% endfor %}
              relabel_configs:
                - source_labels: ['__address__']
                  separator:     ':'
                  regex:         '(.*):.*'
                  target_label:  'instance'
                  replacement:   '${1}'

            - job_name: nginx
              static_configs:
              - targets:
                {% for fqdn, ips in salt.saltutil.runner('mine.get', tgt='role:webserver', fun='network.ip_addrs', tgt_type='grain').items() %}
                - {{ fqdn }}:9113
                {% endfor %}
              relabel_configs:
                - source_labels: ['__address__']
                  separator:     ':'
                  regex:         '(.*):.*'
                  target_label:  'instance'
                  replacement:   '${1}'
