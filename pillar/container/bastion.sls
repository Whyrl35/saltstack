#docker-containers:
  #  lookup:
#    sshportal:
#      image: "moul/sshportal:latest"
#      cmd:
#      runoptions:
#        - "-p 2222:2222"
#        - "-v '/srv:/srv'"
#        - "-w '/srv'"
#        - "-d"

docker:
  compose:
    sshportal:
      image: "moul/sshportal:latest"
      container_name: "sshportal"
      ports:
        - '2222:2222'
      volumes:
        - '/srv:/srv'
      deploy:
        restart_policy:
          condition: 'always'
