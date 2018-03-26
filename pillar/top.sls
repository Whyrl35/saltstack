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
