#!jinja|yaml|gpg
{% set secret = salt['vault'].read_secret('secret/salt/portainer/edge/docker01.cloud.whyrl.fr') %}
{% set grafana_secret = salt['vault'].read_secret('secret/salt/grafana') %}
{% set database_secret = salt['vault'].read_secret('secret/salt/databases/mysql') %}

docker:
  containers:
    running:
      - portainer
      - grafana

    portainer:
      name: portainer_edge_agent
      image: "portainer/agent:latest"
      binds:
        - /var/run/docker.sock:/var/run/docker.sock
        - /var/lib/docker/volumes:/var/lib/docker/volumes
        - /:/host
        - portainer_agent_data:/data
      env:
        - EDGE=1
        - EDGE_ID={{ secret['id'] }}
        - EDGE_KEY={{ secret['key'] }}
        - EDGE_INSECURE_POLL=1
      start: true
      detatch: true
      #auto_remove: true
      privilegde: true
      network_disabled: false
      network_mode: bridge
      restart_policy: always

    grafana:
      name: grafana
      image: "grafana/grafana-oss:9.3.2"
      binds:
        - grafana-storage:/var/lib/grafana
      port_bindings:
        - 3000:3000
      env:
        - "GF_SECURITY_ADMIN_PASSWORD={{ grafana_secret['admin_password'] }}"
        - GF_SERVER_ROOT_URL=https://grafana.whyrl.fr
        # - "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource"
        - GF_DATABASE_HOST=mysql-caaca600-o37d65b73.database.cloud.ovh.net:20184
        - GF_DATABASE_NAME=grafana
        - GF_DATABASE_USER=grafana
        - GF_DATABASE_PASSWORD={{ database_secret['grafana'] }}
        - GF_DATABASE_TYPE=mysql
        - GF_DATABASE_MAX_OPEN_CONN=300
        - GF_SMTP_ENABLED=true
        - GF_SMTP_HOST={{ salt.grains.get('fqdn') }}:25
        - GF_SMTP_FROM_ADDRESS=no-reply@{{ salt.grains.get('fqdn', 'whyrl.fr') }}
        - GF_SMTP_FROM_NAME=Grafana
        - GF_SMTP_SKIP_VERIFY=true
        #- GF_SMTP_STARTTLS_POLICY=MandatoryStartTLS
        #- GF_LOG_LEVEL=debug
      start: true
      detatch: true
      restart_policy: always
