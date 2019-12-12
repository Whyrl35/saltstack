docker-containers:
  lookup:
    sshportal:
      image: "moul/sshportal:latest"
      cmd: ~
      #args:
      pull_before_start: true
      remove_on_stop: true
      runoptions:
        - "-p 2222:2222"
        - "-v '/srv:/srv'"
        - "-w '/srv'"
