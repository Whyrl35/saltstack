apt:
  #
  # Default APT module configuration
  #
#remove_apt_conf: true
#clean_apt_conf_d: true

#remove_sources_list: true
#clean_sources_list_d: true

#remove_preferences: true
#clean_preferences_d: true

  #
  # Unattended
  #
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
  #
  # GLOBAL repository, disposed on all hosts
  #
  repositories:
    # Metrics repository include :
    # noderig and beamium
    metrics:
      distro: buster {# grains['oscodename']|lower if 'oscodename' in grains else 'buster' #}
      url: http://last.public.ovh.metrics.snap.mirrors.ovh.net/debian
      comps: [main]
      keyid: A7F0D217C80D5BB8
      key_url: http://last.public.ovh.metrics.snap.mirrors.ovh.net/pub.key

    # Wigo is a light pull/push monitoring agent
    # https://github.com/root-gg/wigo
    wigo:
      distro: buster {# grains['oscodename']|lower if 'oscodename' in grains else 'buster' #}
      url: http://deb.carsso.com
      comps: [main]
      key_url: http://deb.carsso.com/deb.carsso.com.key

    # Saltstack repo include all the saltstack master/minion
    # Needed to update the binaries on server and agent
    saltstack:
      distro: {{ grains['oscodename']|lower if 'oscodename' in grains else 'buster' }}
      url: http://repo.saltstack.com/py3/debian/{{ grains['osrelease'] }}/amd64/latest
      comps: [main]
      keyid: 0E08A149DE57BFBE
      keyserver: hkp://pgp.mit.edu:80

    #
    # WAZUH repository
    #
    wazuh:
      distro: stable
      url: https://packages.wazuh.com/4.x/apt
      comps: [main]
      key_url: https://packages.wazuh.com/key/GPG-KEY-WAZUH

    #
    # rspamd
    #
    {% if 'mail_server' in grains['roles'] %}
    rspamd:
      distro: {{ grains['oscodename']|lower if 'oscodename' in grains else 'buster' }}
      url: http://rspamd.com/apt-stable
      comps: [main]
      key_url: https://rspamd.com/apt-stable/gpg.key
    {% endif %}
