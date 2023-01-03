{% set host = salt.grains.get('host') %}

docker:
  install_pypi_pip: true

  pkg:
    version: 'latest'  # linux native package version
    name: "docker-ce"

    docker:
      use_upstream: "package"
      service:
        name: "docker"
      daemon_config:
        metrics-addr: "0.0.0.0:9101"
        experimental : true
      {% if salt.grains.get('host') == 'srv002' %}
        log-driver: "journald"
        storage-driver: "overlay2"
      {% endif %}

  containers:
    skip_translate: ports
    force_present: false
    force_running: true
