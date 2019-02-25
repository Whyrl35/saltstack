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

  #
  # GLOBAL repository, disposed on all hosts
  #
  repositories:
    # Metrics repository include :
    # noderig and beamium
    metrics:
      distro: stretch
      url: http://last.public.ovh.metrics.snap.mirrors.ovh.net/debian/
      comps: [main]
      arch: [amd64, i386]
      key_url: http://last.public.ovh.metrics.snap.mirrors.ovh.net/pub.key

    # Saltstack repo include all the saltstack master/minion
    # Needed to update the binaries on server and agent
    saltstack:
      distro: stretch
      url: https://repo.saltstack.com/apt/debian/9/amd64/latest
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
      distro: stretch
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
    elastic-6.x:
      distro: stable
      url: https://artifacts.elastic.co/packages/6.x/apt
      comps: [main]
      arch: [amd64]
      key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    {% endif %}

    #
    # rspamd
    #
    {% if 'mail_server' in grains['roles'] %}
    rspamd:
      distro: stretch
      url: http://rspamd.com/apt-stable
      comps: [main]
      arch: [amd64]
      key_url: https://rspamd.com/apt-stable/gpg.key
    {% endif %}
