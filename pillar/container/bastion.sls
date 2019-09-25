docker-containers:
  lookup:
    sshportal:
      image: "moul/sshportal:latest"
      cmd:
      runoptions:
        - "-p 2222:2222"
        - "-v '/srv:/srv'"
        - "-w '/srv'"
        - "-d"
