{% set host = salt.grains.get('host') %}

docker:
  install_pypi_pip: true

  pkg:
    version: 'latest'  # linux native package version
    name: docker-ce

    docker:
      use_upstream: package
      service:
        name: docker
      {%- if salt.grains.get('host') == 'srv002' %}
      daemon_config:
        log-driver: "journald"
        storage-driver: overlay2
      {% endif -%}

  containers:
    skip_translate: ports
    force_present: false
    force_running: true

{% if (salt.grains.get('host') != 'srv002') and ('swarm' not in grains['roles'] ) %}
    running:
      - portainer

    portainer:
      name: portainer_agent
      image: "portainer/agent:latest"
      binds:
        - /var/run/docker.sock:/var/run/docker.sock
        - /var/lib/docker/volumes:/var/lib/docker/volumes
      port_bindings:
        - 9001:9001
      start: true
      detatch: true
      #auto_remove: true
      privilegde: true
      network_disabled: false
      network_mode: bridge
      restart_policy: always
{% endif %}
