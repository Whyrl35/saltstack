base:
  #
  # Present on all hosts / common
  #
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

  #
  # Specific configuration / hosts/roles based
  #
  'deployment:gra':
    - match: grain
    - ipset.monitoring

  'roles:bastion':
    - match: grain
    - iptables.bastion
    - container.bastion

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

  'ks001.whyrl.fr':
    # FIXME: need to migrate on nginx and automate letsencrypt
    - iptables.webserver
    - schedule

  # Must be executed on all host, but for now, only on specific
  'vps*':
    - schedule
