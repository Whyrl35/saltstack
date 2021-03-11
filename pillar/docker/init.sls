{% set host = salt.grains.get('host') %}

docker:
  install_pypi_pip: true
  pkg:
    allow_updates: true
    use_upstream_app: false
  #docker:
    #   use_upstream: package

  containers:
    skip_translate: ports
    force_present: false
    force_running: true

{% if salt.grains.get('host') != 'srv002' %}
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
{% endif %}
