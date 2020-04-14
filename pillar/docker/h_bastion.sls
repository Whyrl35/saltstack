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
        - "-e CONF_PATH=/data"
    swagger-ui:
      image: "swaggerapi/swagger-ui"
      cmd: ~
      pull_before_start: true
      remove_on_stop: true
      runoptions:
        - "-p 8001:8080"
        - '-e URLS="[ { url: \"https://bastion.whyrl.fr/api/v1/spec.json\", name: \"sshportal-api\" } ]'
