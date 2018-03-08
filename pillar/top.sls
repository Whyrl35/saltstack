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

  'roles:wazuh_server':
    - match: grain
    - kibana

  'roles:mail_server':
    - match: grain
    - mysql
    - letsencrypt
    - nginx
    - postfix
    - dovecot
