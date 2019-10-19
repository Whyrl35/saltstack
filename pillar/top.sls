base:
  #
  # Present on all hosts / common
  #
  '*':
    - schedule
    - default
    - apt
    - openssh
    - account
    - beamium
    - noderig
    - wazuh
    - wigo
    - postfix
    - postfix-satellite

  'not G@roles:saltstack':
    - ipset
    - iptables
    - iptables.common

  'vps*':
    - nftables

  #
  # Specific configuration / hosts/roles based
  #
  'roles:bastion':
    - match: grain
    - iptables.bastion
    - iptables.portainer
    - container.bastion

  'roles:wazuh_server':
    - match: grain
    - iptables.webserver
    - iptables.wazuh
    - letsencrypt
    - nginx
    - elk.kibana
    - elk.filebeat

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
    - iptables.portainer

