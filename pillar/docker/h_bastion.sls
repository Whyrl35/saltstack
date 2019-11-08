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

#docker:
#  compose:
#    sshportal:
#      image: "moul/sshportal:latest"
#      container_name: "sshportal"
#      ports:
#        - '2222:2222'
#      volumes:
#        - '/srv:/srv'
#      deploy:
#        restart_policy:
#          condition: 'always'
#    portainer:
#      image: "portainer/agent"
#      container_name: "portainer_agent"
#      ports:
#        - '9001:9001'
#      volumes:
#        - '/var/run/docker.sock:/var/run/docker.sock '
#        - '/var/lib/docker/volumes:/var/lib/docker.volumes'
#      deploy:
#        restart_policy:
#          condition: 'always'
#    test:
#      image: "hello-world"
#      container_name: "hello_world"
