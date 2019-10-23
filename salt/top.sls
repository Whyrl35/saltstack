# All files will be taken from the file path specified in the base
# environment in the ``file_roots`` configuration value.

base:
  #
  # All minions get the following state files applied
  #
  '*':
    # may filter on debian hosts (grain os)
    - apt.transports.https
    - apt.repositories
    - apt.update
    - apt.unattended
    - common
    # everything in common :
    - motd
    - zsh
    # my account and tools
    - account
    # openssh specific configuration
    - openssh
    - openssh.client
    - openssh.config
    - openssh.banner
    - openssh.auth
    # firewalling
    - nftables

  #
  # Monitoring (for i686, build it manually)
  #
  'cpuarch:x86_64':
    - match: grain
    # monitoring
    - wigo
    # metrics
    - beamium
    - noderig

  #
  # Minions that have a grain set indicating that they are running
  # the docker system will have the state file called
  # in the docker formulas in the 'repos' directory applied.
  #
  # Again take note of the 'match' directive here which tells
  # Salt to match against a grain instead of a minion ID.
  #
  'roles:container':
    - match: grain
    - docker
    - docker.compose

  #
  # Bastion server, may be only one host, that run the bastion container
  # include the docker.containers state
  #
  'roles:bastion':
    - match: grain
    - docker.containers

  #
  # Wazuh server, may be only one host, that run the wazuh stack
  # include the wazuh state
  #
  # Match again the roles 'wazuh_server'
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
    # - elk.logstash
    - elk.kibana

  #
  # Wazuh client, should be all hosts, that run the wazuh stack
  # include the wazuh state
  #
  # Match again the roles 'wazuh_agent'
  #
  'roles:wazuh_agent':
    - match: grain
    - wazuh.agent

  #
  # Mail server, will run a stack of postfix/dovecot ta manage mail
  # need many features and some formulas
  #
  # Again take note of the 'match' directive here which tells
  # Salt to match against a grain instead of a minion ID.
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
  #
  'not G@roles:mail_server':
    - postfix
    - postfix.config
    - postfix.satellite

  #
  # Specific nodes configuration :
  #
  'srv00*':
    - letsencrypt
    - nginx

