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
      {% if salt.grains.get('host') == 'srv002' %}
      daemon_config:
        log-driver: "journald"
        storage-driver: "overlay2"
      {% endif %}

  containers:
    skip_translate: ports
    force_present: false
    force_running: true
