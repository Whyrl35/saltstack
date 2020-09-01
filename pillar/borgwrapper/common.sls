#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/backup/borgwrapper') %}

borgwrapper:
  configs:
    default:
      repo: ssh://borg@borgbackup.whyrl.fr/srv/borg/{{ grains['id'] }}
      passphrase: {{ secret['passphrase'] }}
      paths:
        - /etc
        - /srv
