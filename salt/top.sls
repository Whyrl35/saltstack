# All files will be taken from the file path specified in the base
# environment in the ``file_roots`` configuration value.

base:
  # All minions get the following state files applied
  '*':
    - apt.transports.https
    - apt.repositories
    - apt.update
    - apt.unattended
    - common
    - packages
    - motd
    - zsh
    - account
    - openssh
    - openssh.client
    - openssh.config
    - openssh.banner
    - openssh.auth
    - nftables
    - wigo
    - beamium
    - noderig
    - promtail
    - logrotate
    - logrotate.jobs
    - restic

  # KS001 specific, for moviecat CI/CD
  'ks*':
    - webhook

  # bastion server
  'roles:bastion':
    - match: grain
    - webhook

  # Saltstack server
  'roles:saltstack':
    - match: grain
    - webhook
    - mysql
    - mysql.server
    - alcali

  # Minions that have a grain set indicating that they are running
  # the docker system will have the state file called
  # in the docker formulas in the 'repos' directory applied.
  'roles:container':
    - match: grain
    - systemd
    - docker
    - docker.compose
    - docker.containers

  'roles:swarm':
    - match: grain
    - swarm

  # Wazuh server, may be only one host, that run the wazuh stack
  # include the wazuh server state + elk + front for kibana
  'roles:wazuh_server':
    - match: grain
    - wazuh
    - webhook

  # Wazuh client, should be all hosts, that are not the wazuh server
  'not G@roles:wazuh_server':
    - wazuh.agent

  # Mail server, will run a stack of postfix/dovecot ta manage mail
  'roles:mail_server':
    - match: grain
    - mysql
    - mysql.server
    - letsencrypt
    - nginx
    - postfixadmin
    - postfix
    - postfix.config
    - postfix.pcre
    - postfix.header_checks
    - postfix.diffiehellman
    - postfix.mysql
    - dovecot
    - rspamd
    - rainloop

  # Postfix for non mail server, aka postfix satellite
  # Will use the `mail_server` as relay
  'not G@roles:mail_server':
    - postfix
    - postfix.config
    - postfix.satellite

  # Webserver using nginx and letsencrypt
  'roles:webserver':
    - match: grain
    - letsencrypt
    - nginx

  # Bitwarden server, will use bitwarden (docker managed)
  'roles:bitwarden':
    - match: grain
    - bitwarden

  # vault server
#'roles:vault':
  #   - match: grain
    #- vault

  # Homeassistant server, will use homeassistant (docker managed)
  'roles:homeassistant':
    - match: grain
    - homeassistant

  # dnsmasq server, will use dnsmasq
  'roles:local_dns':
    - match: grain
    - dnsmasq

  # warp10 server, will use warp10
  'roles:warp10':
    - match: grain
    - java
    - warp10
    - grafana

  # loki server, will use loki
  'roles:loki':
    - match: grain
    - loki

  # smokeping server, will use telegraf
  'roles:smokeping':
    - match: grain
    - telegraf
