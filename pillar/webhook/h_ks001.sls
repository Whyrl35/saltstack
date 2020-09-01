#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/web/webhook') %}

webhooks:
  files:
    - /opt/webhooks/actions/moviecat.sh:
      - source: salt://webhook/files/moviecat.sh
  configurations:
    - id: "moviecat-deployment"
      execute-command: "/opt/webhooks/actions/moviecat.sh"
      command-working-directory: "/srv/moviecat"
      reponses-message: "deploying moviecat..."
      trigger-rule:
        match:
          type: "payload-hash-sha1"
          secret: {{ secret['deploy-moviecat'] }}
          parameter:
            source: "header"
            name: "X-Hub-Signature"

