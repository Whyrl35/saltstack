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
    sshportal-api:
      image: "whyrl/sshportal-api:latest"
      cmd: ~
      pull_before_start: true
      remove_on_stop: true
      runoptions:
        - "-p 8000:8000"
        - "-v '/srv:/data'"
