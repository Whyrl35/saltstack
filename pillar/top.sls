base:
  '*':
    - default
    - apt
    - openssh
    - account
    - ipset
    - ipset_custom
    - iptables
    - iptables_custom
    - beamium
    - noderig
    - wazuh
    - wigo
    - postfix
    - postfix-satellite

  'roles:wazuh_server':
    - match: grain
    - letsencrypt
    - nginx
    - kibana

  'roles:mail_server':
    - match: grain
    - mysql
    - letsencrypt
    - nginx
    - dovecot

  'srv001*':
    - nginx

  'roles:redash':
    - match: grain
    - letsencrypt
    - nginx

  'roles:bastion':
    - match: grain
    - container-bastion
