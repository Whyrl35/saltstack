webhooks:
  files:
    - /opt/webhooks/salt/git-deploy.sh:
      - source: salt://webhook/files/git-deploy.sh
  configurations:
    - id: "salt-git-deployment"
      execute-command: "/opt/webhooks/salt/git-deploy.sh"
      command-working-directory: "/srv"
      reponses-message: "deploying git on salt..."
      trigger-rule:
        match:
          type: "payload-hash-sha1"
          secret: "hUyXzmbm6qh7fhumgNrLVLyzTcUx2Vjo"
          parameter:
            source: "header"
            name: "X-Hub-Signature"
