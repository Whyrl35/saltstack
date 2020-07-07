apt:
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
      distro: {{ grains['oscodename']|lower if 'oscodename' in grains else 'stretch' }}
      url: http://last.public.ovh.metrics.snap.mirrors.ovh.net/debian/
      comps: [main]
      arch: [amd64, i386]
      key_url: http://last.public.ovh.metrics.snap.mirrors.ovh.net/pub.key

    # Wigo is a light pull/push monitoring agent
    # https://github.com/root-gg/wigo
    wigo:
      distro: 'stretch'
      url: http://deb.carsso.com/
      comps: [main]
      arch: [amd64]
      key_url: http://deb.carsso.com/deb.carsso.com.key

    # Saltstack repo include all the saltstack master/minion
    # Needed to update the binaries on server and agent
    saltstack:
      distro: {{ grains['oscodename']|lower if 'oscodename' in grains else 'stretch' }}
      url: http://repo.saltstack.com/py3/debian/{{ grains['osrelease'] }}/amd64/latest
      comps: [main]
      arch: [amd64, i386]
      keyid: 0E08A149DE57BFBE
      keyserver: hkp://pgp.mit.edu:80
    saltstack-archive:
      distro: {{ grains['oscodename']|lower if 'oscodename' in grains else 'stretch' }}
      url: http://repo.saltstack.com/py3/debian/{{ grains['osrelease'] }}/amd64/archive/3000.3
      comps: [main]
      arch: [amd64, i386]
      keyid: 0E08A149DE57BFBE
      keyserver: hkp://pgp.mit.edu:80

    #
    # WAZUH repository
    #
    {% if 'wazuh_server' in grains['roles'] or 'wazuh_agent' in grains['roles'] %}
    wazuh:
      distro: stable
      url: https://packages.wazuh.com/3.x/apt/
      comps: [main]
      key_url: https://packages.wazuh.com/key/GPG-KEY-WAZUH
    {% endif %}

    #
    # NODE.JS
    #
    {% if 'wazuh_server' in grains['roles'] %}
    nodesource:
      distro: {{ grains['oscodename']|lower if 'oscodename' in grains else 'stretch' }}
      url: https://deb.nodesource.com/node_6.x/
      comps: [main]
      arch: [amd64]
      key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    {% endif %}

    #
    # ORACLE JRE
    #
    {% if 'wazuh_server' in grains['roles'] %}
    oracle-jre-8:
      distro: xenial
      url: http://ppa.launchpad.net/webupd8team/java/ubuntu
      comps: [main]
      arch: [amd64]
      keyid: EEA14886
      keyserver: hkp://keyserver.ubuntu.com:8
    {% endif %}


    #
    # Elasticshearch
    #
    {% if 'wazuh_server' in grains['roles'] %}
    elastic-7.x:
      distro: stable
      url: https://artifacts.elastic.co/packages/7.x/apt
      comps: [main]
      arch: [amd64]
      key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    {% endif %}

    #
    # rspamd
    #
    {% if 'mail_server' in grains['roles'] %}
    rspamd:
      distro: {{ grains['oscodename']|lower if 'oscodename' in grains else 'stretch' }}
      url: http://rspamd.com/apt-stable
      comps: [main]
      arch: [amd64]
      key_url: https://rspamd.com/apt-stable/gpg.key
    {% endif %}
