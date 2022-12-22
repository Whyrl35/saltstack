# vim:ft=yaml ts=2 sw=2 sts=2

# All files will be taken from the file path specified in the base
# environment in the ``file_roots`` configuration value.

base:
  # All minions get the following state files applied
  '*':
    - apt.transports.https
    - apt.unattended
    - apt.repositories
    - apt.update
    - common
    - nftables
    - packages
    - restic
    - zsh

  'not G@deployment:sac and not G@deployment:rbx':
    - networking

  # All minions but not the bastion, as the ssh and host configuration is very different
  # Need to do a thebastion state to install and configure everything.
  'not bastion.whyrl.fr':
    - account
    - motd
    - openssh
    - openssh.client
    - openssh.config
    - openssh.banner
    - openssh.auth
    # A prevoir quand certains services seront de retour
    # - promtail

  # loadbalancer servers
  'role:loadbalancer':
    - match: grain
    - haproxy

  # Webserver
  'role:webserver':
    - match: grain
    - certificates
    - nginx

  # DNS servers
  'role:dns-*':
    - match: grain
    - bind
    - bind.config

  # Homeassistant server, will use homeassistant (docker managed)
  #'role:homeassistant':
  #  - match: grain
  #  - homeassistant

  # dnsmasq server, will use dnsmasq
  'role:local_dns':
    - match: grain
    - dnsmasq

  # Minions that have a grain set indicating that they are running
  # the docker system will have the state file called
  # in the docker formulas in the 'repos' directory applied.
  'role:container':
    - match: grain
    - systemd
    - docker
    - docker.compose
    - docker.containers

  # Mail server, will run a stack of postfix/dovecot ta manage mail
  'role:mailserver':
    - match: grain
    - certificates
    - postfixadmin
    - postfix
    - postfix.config
    - postfix.pcre
    - postfix.header_checks
    - postfix.diffiehellman
    - postfix.mysql
    - dovecot
    - rspamd
    # XXX: faire un module - roundcubemail

  # Postfix for non mail server, aka postfix satellite
  # Will use the `mail_server` as relay
  'not G@role:mailserver':
    - postfix
    - postfix.config
    - postfix.satellite



#  # Saltstack server
#  'role:saltstack':
#    - match: grain
#    - webhook
#    - mysql
#    - mysql.server
#    - alcali
#
#
#  'role:swarm':
#    - match: grain
#    - swarm
#
#  # Wazuh server, may be only one host, that run the wazuh stack
#  # include the wazuh server state + elk + front for kibana
#  'role:wazuh_server':
#    - match: grain
#    #TODO: need rewriting again
#    #- wazuh
#    - webhook
#
#  # Wazuh client, should be all hosts, that are not the wazuh server
#  'not G@role:wazuh_server':
#    - wazuh.agent
#
#  # Mail server, will run a stack of postfix/dovecot ta manage mail
#  'role:mail_server':
#    - match: grain
#    - mysql
#    - mysql.server
#    - certificates
#    #- letsencrypt
#    - nginx
#    - postfixadmin
#    - postfix
#    - postfix.config
#    - postfix.pcre
#    - postfix.header_checks
#    - postfix.diffiehellman
#    - postfix.mysql
#    - dovecot
#    - rspamd
#    - rainloop
#
#  # Postfix for non mail server, aka postfix satellite
#  # Will use the `mail_server` as relay
#  'not G@role:mail_server':
#    - postfix
#    - postfix.config
#    - postfix.satellite
#
#  # Webserver
#  'role:webserver':
#    - match: grain
#    - certificates
#    - nginx
#
#  # Bitwarden server, will use bitwarden (docker managed)
#  'role:bitwarden':
#    - match: grain
#    - bitwarden
#
#  # vault server
#  #'role:vault':
#  # - match: grain
#  # - vault
#
#  # Homeassistant server, will use homeassistant (docker managed)
#  #'role:homeassistant':
#  #  - match: grain
#  #  - homeassistant
#
#  # dnsmasq server, will use dnsmasq
#  'role:local_dns':
#    - match: grain
#    - dnsmasq
#
#  # warp10 server, will use warp10
#  'role:warp10':
#    - match: grain
#    - java
#    - warp10
#    - grafana
#
#  # loki server, will use loki
#  'role:loki':
#    - match: grain
#    - loki
#
#  # smokeping server, will use telegraf
#  'role:smokeping':
#    - match: grain
#    - telegraf
#
#  # glusterfs servers
#  'role:glusterfs':
#    - match: grain
#    - glusterfs.server
#
#  # webserver in backend, no front exposure
#  'role:webserver-back':
#    - match: grain
#    - glusterfs.client
#    - pen
#    - nginx
#    - webhook
#
#  # galera server, mariadb cluster
#  'role:galera':
#    - match: grain
#    - galera
#
#
#
#  # Nexus servers
#  'role:nexus*':
#    - match: grain
#    - java
#    - nexus
#
#  # Firezone servers
#  'role:firezone':
#    - match: grain
#    - firezone
