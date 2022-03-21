#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/web/webhook') %}

webhooks:
  files:
    - /opt/webhooks/salt/git-deploy.sh:
      - source: salt://webhook/files/git-deploy.sh
  configurations:
    - id: "salt-github-deployment"
      execute-command: "/opt/webhooks/salt/git-deploy.sh"
      command-working-directory: "/srv"
      reponses-message: "deploying git on salt..."
      trigger-rule:
        match:
          type: "payload-hash-sha1"
          secret: {{ secret['deploy-saltstack'] }}
          parameter:
            source: "header"
            name: "X-Hub-Signature"
    - id: "salt-drone-deployment"
      execute-command: "/opt/webhooks/salt/git-deploy.sh"
      command-working-directory: "/srv"
      reponses-message: "deploying git on salt..."
      trigger-rule:
        match:
          type: "value"
          value: "{{ secret['deploy-saltstack'] }}"
          parameter:
            source: "header"
            name: "X-Drone-Token"
