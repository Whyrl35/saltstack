base:
  '*':
    - default
    - apt
    - openssh
    - account
    - ipset
    - ipset.bastion
    - ipset.blacklist
    - ipset.myhosts
    - iptables
    - iptables.common
    - beamium
    - noderig
    - wazuh
    - wigo
    - postfix
    - postfix-satellite

  # Must be executed on all host, but for now, only on specific
  'vps*':
    - schedule

  'deployment:gra':
    - match: grain
    - ipset.monitoring

  'roles:wazuh_server':
    - match: grain
    - iptables.webserver
    - iptables.wazuh
    - letsencrypt
    - nginx
    - kibana

  'roles:mail_server':
    - match: grain
    - iptables.webserver
    - iptables.mail
    - mysql
    - letsencrypt
    - nginx
    - dovecot

  'srv00*':
    - iptables.webserver
    - letsencrypt
    - nginx

  'roles:bastion':
    - match: grain
    - iptables.bastion
    - container.bastion
