webhooks:
  files:
    - /opt/webhooks/salt/git-deploy.sh:
      - source: salt://webhook/files/git-deploy.sh
  configurations:
    - id: "salt-git-deployment"
      execute_command: "/opt/webhooks/salt/git-deploy.sh"
      working_directory: "/srv"
      reponse_message: "deploying git on salt..."
      triggers:
        match:
          type: "payload-hash-sha1"
          secret: "hUyXzmbm6qh7fhumgNrLVLyzTcUx2Vjo"
          parameter:
            source: "header"
            name: "X-Hub-Signature"
