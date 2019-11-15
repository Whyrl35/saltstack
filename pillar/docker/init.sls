{% set host = salt.grains.get('host') %}

docker:
  install_pypi_pip: true
  pkg:
    allow_updates: true
    use_upstream_app: false
  #config:
    #- DOCKER_OPTS="-s btrfs --dns 8.8.8.8"
    #- export http_proxy="http://172.17.42.1:3128"
  containers:
    skip_translate: ports
    force_present: false
    force_running: true

{% if salt.grains.get('host') != 'srv002' %}
docker-containers:
  lookup:
    portainer_agent:
      image: "portainer/agent"
      cmd: ~
      #args:
      pull_before_start: true
      remove_on_stop: true
      runoptions:
        - "-p target=9001,published=9001"
        - "-v /var/run/docker.sock:/var/run/docker.sock"
        - "-v /var/lib/docker/volumes:/var/lib/docker/volumes"
{% endif %}

include:
    - docker.h_{{ host }}
