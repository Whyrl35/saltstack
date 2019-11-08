docker-containers:
  lookup:
    portainer:
      image: "portainer/portainer"
      cmd: ~
      #args:
      pull_before_start: true
      remove_on_stop: false
      runoptions:
        - "-p 8000:8000"
        - "-p 9000:9000"
        - "-v portainer_data:/data"
