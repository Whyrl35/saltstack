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
    ludovic-valid-ssh-key-ansible@saltmaster:
      - user: ansible
        present: True
        enc: ssh-ed25519
        comment: ansible@saltmaster
        source: salt://ssh/keys/id_ed25519_ansible_saltmaster.pub
    {% if grains['deployment'][0:3] in ['gra','bhs'] %}
    ludovic-valid-ssh-key-bastion-cloud:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: bastion
        source: salt://ssh/keys/id_ed25519_cloud_bastion.pub
    {% endif %}
