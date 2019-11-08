# All files will be taken from the file path specified in the base
# environment in the ``file_roots`` configuration value.

base:
  #
  # All minions get the following state files applied
  #
  '*':
    - apt.transports.https
    - apt.repositories
    - apt.update
    - apt.unattended
    - common
    - motd
    - zsh
    - account
    - openssh
    - openssh.client
    - openssh.config
    - openssh.banner
    - openssh.auth
    - nftables

  #
  # Monitoring (for i686, build it manually)
  #
  'cpuarch:x86_64':
    - match: grain
    - wigo
    - beamium
    - noderig

  #
  # Minions that have a grain set indicating that they are running
  # the docker system will have the state file called
  # in the docker formulas in the 'repos' directory applied.
  #
  'roles:container':
    - match: grain
    - docker
    - docker.compose
    - docker.containers

  #
  # Wazuh server, may be only one host, that run the wazuh stack
  # include the wazuh server state + elk + front for kibana
  #
  'roles:wazuh_server':
    - match: grain
    - letsencrypt
    - nginx
    - wazuh.manager
    - wazuh.api
    - oracle.jre8
    - elk.elasticsearch
    - elk.filebeat
    - elk.kibana

  #
  # Wazuh client, should be all hosts, that run the wazuh stack
  # include the wazuh agent state
  #
  'roles:wazuh_agent':
    - match: grain
    - wazuh.agent

  #
  # Mail server, will run a stack of postfix/dovecot ta manage mail
  # need many features and some formulas
  #
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

  #
  # Postfix for non mail server, aka postfix satellite
  # Will use the `mail_server` as relay
  #
  'not G@roles:mail_server':
    - postfix
    - postfix.config
    - postfix.satellite

  #
  # Webserver using nginx and letsencrypt
  #
  'roles:webserver':
    - match: grain
    - letsencrypt
    - nginx
