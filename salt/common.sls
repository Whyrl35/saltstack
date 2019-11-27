common:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - curl
      - sudo
      - htop
      - git
      - vim
      - vim-nox
      - lsb-release
      - unattended-upgrades
      - apt-listchanges
      - ipv6calc

127.0.1.1:
  host.only:
    - hostnames:
      - {{ grains['id'] }}
      - {{ grains['id'].split('.', 1)[0] }}
