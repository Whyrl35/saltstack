openssh:
  sshd_enable: true
  auth:
    ludovic-valid-ssh-key-desk:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: lhoudaye@desk
        source: salt://ssh/keys/id_rsa_desk.pub
    ludovic-valid-ssh-key-srv001:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: ludovic@srv001
        source: salt://ssh/keys/id_rsa_srv001.pub
    {% if grains['deployment'][0:3] in ['gra'] %}
    ludovic-valid-ssh-key-bastion-cloud:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: bastion
        source: salt://ssh/keys/id_ed25519_cloud_bastion.pub
    {% endif %}
