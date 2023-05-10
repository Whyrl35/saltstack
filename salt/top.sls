# vim:ft=yaml ts=2 sw=2 sts=2

# All files will be taken from the file path specified in the base
# environment in the ``file_roots`` configuration value.

base:
  # All minions get the following state files applied
  '*':
    - apt.transports.https
    - apt.unattended
    - apt.repositories
    - apt.apt_conf
    - apt.update
    - common
    - logrotate
    - logrotate.jobs
    - nftables
    - packages
    - prometheus
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
    - promtail

  # Saltstack server
  'role:saltstack':
    - match: grain
    - webhook

  # loadbalancer servers
  'role:loadbalancer':
    - match: grain
    - haproxy

  # Webserver
  'role:webserver':
    - match: grain
    - certificates
    - nginx
  'web*':
    - php.cli
    - php.fpm
    - php.mysql
    - php.gd
    - php.intl
    - php.mbstring
    - php.imagick
    - php.curl
    - php.zip
    - php.xml
    - mysql.client
    - wordpress

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
    #- docker.compose
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
    - roundcubemail

  # Postfix for non mail server, aka postfix satellite
  # Will use the `mail_server` as relay
  'not G@role:mailserver':
    - postfix
    - postfix.config
    - postfix.satellite

  # Mail server, will run a stack of promotheus manage monitoring
  'role:prometheus':
    - match: grain
    - prometheus

  # loki server, will use loki
  'role:loki':
    - match: grain
    - loki

  # Firezone servers
  # 'role:firezone':
    # - match: grain
    # - firezone

  # Wireguard VPN servers
  'role:wireguard':
    - match: grain
    - wireguard
