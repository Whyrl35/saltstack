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
      - python3-psutil
      # - duf # XXX backport only
      - ncdu
      - exa
      - bat
      {% if 'smokeping' in grains['roles'] %}
      - python3-pip
      {% endif %}
