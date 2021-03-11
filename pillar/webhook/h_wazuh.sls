#!jinja|yaml|gpg

webhooks:
  #files:
  #  - /opt/webhooks/actions/wigo-to-slack.py:
  #    - source: salt://webhook/files/wigo-to-slack.py
  configurations:
    - id: "wigo-to-slack"
      execute-command: "/opt/webhooks/actions/wigo-to-slack.py"
      pass-arguments-to-command:
        - source: payload
          name: Notification
      command-working-directory: "/tmp"
      reponses-message: "sending message to slack..."
