common:
  pkg.installed:
    - pkgs:
      - w3m
      - curl
      - sudo
      - htop
      - git
      - vim
      - apt-transport-https
      - lsb-release
      - unattended-upgrades
      - apt-listchanges
      - ipv6calc

127.0.1.1:
  host.only:
    - hostnames:
      - {{ grains['id'] }}
      - {{ grains['id'].split('.', 1)[0] }}
