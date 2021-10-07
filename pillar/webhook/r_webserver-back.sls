#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/web/webhook') %}

webhooks:
  files:
    - /opt/webhooks/hugo/hugo-artifact-deploy.sh:
      - source: salt://webhook/files/hugo-artifact-deploy.sh
  configurations:
    - id: "hugo-artifact-deployment"
      execute-command: "/opt/webhooks/hugo/hugo-artifact-deploy.sh"
      command-working-directory: "/tmp"
      reponses-message: "deploying website..."
      trigger-rule:
        match:
          type: "payload-hash-sha1"
          secret: {{ secret['deploy-hugo-artifact'] }}
          parameter:
            source: "header"
            name: "X-Hub-Signature"
