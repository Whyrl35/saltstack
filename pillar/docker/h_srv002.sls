docker-containers:
  lookup:
    portainer:
      image: "portainer/portainer"
      cmd: ~
      #args:
      pull_before_start: true
      remove_on_stop: true
      runoptions:
        - "-p 8000:8000"
        - "-p 9000:9000"
        - "-v /srv/portainer/data:/data"
        - "-v /var/run/docker.sock:/var/run/docker.sock"
