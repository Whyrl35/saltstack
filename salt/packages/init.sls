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
      - python3-psutil
      - python3-dnspython
      # - duf # XXX backport only
      - ncdu
      - exa
      - bat
      {% if 'smokeping' in grains['roles'] %}
      - python3-pip
      {% endif %}
