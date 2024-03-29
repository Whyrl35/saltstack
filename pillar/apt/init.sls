apt:
  apt_conf_d:
    80PhasedUpdates:
      'APT::Get::Always-Include-Phased-Updates': "true"

  unattended:
    auto_fix_interrupted_dpkg: true
    minimal_steps: false
    install_on_shutdown: false
    mail: ludovic+unattended@whyrl.fr
    mail_only_on_error: false
    remove_unused_dependencies: true
    automatic_reboot: false
    dl_limit: 0
    enabled: 1
    update_package_lists: 1
    download_upgradeable_packages: 1
    unattended_upgrade: 1
    auto_clean_interval: 7
    verbose: 2
    origins_patterns:
      - origin=SaltStack
      - origin=Debian,archive=stable,label=Debian-Security
      - origin=Debian,archive=oldstable,label=Debian-Security
      - origin=Debian,archive=stable-security,label=Debian-Security
      - origin=Debian,archive=oldstable-security,label=Debian-Security

  repositories:
    saltstack:
      distro: {{ grains['oscodename']|lower if 'oscodename' in grains else 'bullseye' }}
      url: https://repo.saltproject.io/salt/py3/debian/{{ grains['osrelease'] }}/amd64/latest
      {# url: https://repo.saltproject.io/salt/py3/debian/11/amd64/3006 #}
      comps: [main]
      key_url: https://repo.saltproject.io/salt/py3/debian/11/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
      opts: "signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg"
