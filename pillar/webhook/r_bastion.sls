#!jinja|yaml|gpg
webhooks:
  files:
    - /opt/webhooks/salt/sshportal-api.sh:
      - source: salt://webhook/files/sshportal-api.sh
  configurations:
    - id: "sshportal-api-deployment"
      execute-command: "/opt/webhooks/salt/sshportal-api.sh"
      command-working-directory: "/srv"
      reponses-message: "deploying sshportal-api..."
