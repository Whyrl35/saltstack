docker:
  containers:
    running:
      - portainer
      - swagger-ui
      - sshportal-ui
      - sshportal-api
      - sshportal

    swagger-ui:
      name: swagger-ui
      image: "swaggerapi/swagger-ui"
      port_bindings:
        - 8001:8080
      environment:
        - URLS: '[ { url: "https://bastion.whyrl.fr/api/v1/spec.json", name: "sshportal-api" } ]'
      start: true
      detatch: true
      auto_remove: false
      privilegde: false
      network_disabled: false
      network_mode: bridge
      restart_policy: always

    sshportal-ui:
      name: sshportal-ui
      image: "whyrl/sshportal-ui:latest"
      port_bindings:
        - 8002:80
      start: true
      detatch: true
      auto_remove: false
      privilegde: false
      network_disabled: false
      network_mode: bridge
      restart_policy: always

    sshportal-api:
      name: sshportal-api
      image: "whyrl/sshportal-api:latest"
      port_bindings:
        - 8000:8000
      binds:
        - /srv/:/data
      environment:
        - CONF_PATH: /data
      start: true
      detatch: true
      auto_remove: false
      privilegde: false
      network_disabled: false
      network_mode: bridge
      restart_policy: always

    sshportal:
      name: sshportal
      image: "moul/sshportal:latest"
      port_bindings:
        - 2222:2222
      binds:
        - /srv/:/srv
      working_dir: /srv
      start: true
      detatch: true
      auto_remove: false
      privilegde: false
      network_disabled: false
      network_mode: bridge
      restart_policy: always
