apt:
  repositories:
    #
    # GLOBAL repository, disposed on all hosts
    #

    # Metrics repository include :
    # noderig and beamium
    metrics:
      distro: stretch
      url: http://last.public.ovh.metrics.snap.mirrors.ovh.net/debian/
      comps: [main]
      arch: [amd64, i386]
      keyid: A7F0D217C80D5BB8
      keyserver: hkp://pgp.mit.edu:80

    # Saltstack repo include all the saltstack master/minion
    # Needed to update the binaries on server and agent
    saltstack:
      distro: stretch
      url: https://repo.saltstack.com/apt/debian/9/amd64/latest
      comps: [main]
      arch: [amd64, i386]
      keyid: 0E08A149DE57BFBE
      keyserver: hkp://pgp.mit.edu:80

    # Wigo is a local monitoring client (like OVH oco)
    # Can be centralized in a master
    wigo:
      distro: stretch
      url: http://deb.carsso.com
      comps: [main]
      arch: [amd64]
      key_url: http://deb.carsso.com/deb.carsso.com.key

    #
    # WAZUH repository
    #
    {% if 'wazuh_server' in grains['roles'] or 'wazuh_agent' in grains['roles'] %}
    wazuh:
      distro: stable
      url: https://packages.wazuh.com/3.x/apt/
      comps: [main]
      arch: [amd64]
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

