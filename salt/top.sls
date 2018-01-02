# All files will be taken from the file path specified in the base
# environment in the ``file_roots`` configuration value.

base:
  # All minions get the following state files applied
  '*':
    #
    # may filter on debian hosts (grain os)
    - apt.transports.https
    - apt.repositories
    - apt.update
    - common
    #
    # everythin in common :
    - motd
    - zsh
    #
    # my account and tools
    - account
    #
    # openssh specific configuration
    - openssh
    - openssh.client
    - openssh.config
    - openssh.banner
    - openssh.auth
    #
    # ipset and iptables protection
    - ipset
    - iptables
    #
    # monitoring
    - beamium
    - noderig


  # Minions that have a grain set indicating that they are running
  # the docker system will have the state file called
  # in the docker formulas in the 'repos' directory applied.
  #
  # Again take note of the 'match' directive here which tells
  # Salt to match against a grain instead of a minion ID.
  'roles:container':
    - match: grain
    - docker
    - docker.compose


  # Wazuh server, may be only one host, that run the wazuh stack
  # include the wazuh state
  #
  # Match again the roles 'wazuh_server'
  'roles:wazuh_server':
    - match: grain
    - wazuh.manager
    - wazuh.api
    - oracle.jre8
    - elk.filebeat
    - elk.elasticsearch
    - elk.logstash
    - elk.kibana


  # Wazuh client, should be all hosts, that run the wazuh stack
  # include the wazuh state
  #
  # Match again the roles 'wazuh_agent'
  'roles:wazuh_agent':
    - match: grain
    - wazuh.agent
