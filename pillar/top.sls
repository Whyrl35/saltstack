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
    - ipset
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

