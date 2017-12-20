# All files will be taken from the file path specified in the base
# environment in the ``file_roots`` configuration value.

base:

  # All minions get the following state files applied
  '*':
    - apt.transports.https
    - apt.repositories
    - apt.update
    - common
    - motd
    - zsh
    - openssh
    - openssh.client
    - openssh.config
    - openssh.banner
    - openssh.auth
    - ipset
    - iptables
    - account
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
