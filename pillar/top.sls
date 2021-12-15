{% set host = salt.grains.get('host') %}

base:
  #
  # Present on all hosts / common
  #
  '*':
    - schedule
    - default
    - apt
    - openssh
    - nftables
    - nftables.h_{{ host }}
    {% for role in grains['roles'] %}
    - nftables.r_{{ role }}
    {% endfor %}
    - account
    - beamium
    - beamium.h_{{ host }}
    {% for role in grains['roles'] %}
    - beamium.r_{{ role }}
    {% endfor %}
    - noderig
    - wazuh
    - wigo
    - wigo.common
    {% for role in grains['roles'] %}
    - wigo.r_{{ role }}
    {% endfor %}
    - wigo.h_{{ host }}
    #- borgbackup
    - restic
    - promtail
    - ignore_missing: True

  #
  # Specific configuration / hosts/roles based
  #
  'ks*':
    - webhook
    - webhook.h_{{ host }}
    {% for role in grains['roles'] %}
    - webhook.r_{{ role }}
    {% endfor %}
    - ignore_missing: True

  'roles:bastion':
    - match: grain
    - webhook
    - webhook.h_{{ host }}
    {% for role in grains['roles'] %}
    - webhook.r_{{ role }}
    {% endfor %}
    - ignore_missing: True

  'roles:saltstack':
    - match: grain
    - webhook
    - webhook.h_{{ host }}
    {% for role in grains['roles'] %}
    - webhook.r_{{ role }}
    {% endfor %}
    - mysql
    - mysql.h_{{ host }}
    - alcali
    - ignore_missing: True

  'roles:container':
    - match: grain
    - docker
    - docker.h_{{ host }}
    - ignore_missing: True

  'roles:swarm':
    - match: grain
    - swarm

  'roles:wazuh_server':
    - match: grain
    - webhook
    - ignore_missing: True

  'roles:mail_server':
    - match: grain
    - postfix
    - mysql
    {% for role in grains['roles'] %}
    - mysql.r_{{ role }}
    {% endfor %}
    - mysql.h_{{ host }}
    - letsencrypt
    - letsencrypt
    {% for role in grains['roles'] %}
    - letsencrypt.r_{{ role }}
    {% endfor %}
    - letsencrypt.h_{{ host }}
    - nginx
    - dovecot
    - ignore_missing: True

  'not G@roles:mail_server':
    - postfix.satellite
    - ignore_missing: True

  'roles:webserver':
    - match: grain
    - letsencrypt
    {% for role in grains['roles'] %}
    - letsencrypt.r_{{ role }}
    {% endfor %}
    - letsencrypt.h_{{ host }}
    - nginx
    - logrotate.nginx
    - ignore_missing: True

  #'not G@roles:borgbackup':
  #  - borgwrapper
  #  - borgwrapper.h_{{ host }}
  #  {% for role in grains['roles'] %}
  #  - borgwrapper.r_{{ role }}
  #  {% endfor %}
  #  - ignore_missing: True

  'roles:bitwarden':
    - match: grain
    - bitwarden
    - ignore_missing: True

  'roles:homeassistant':
    - match: grain
    - homeassistant
    - ignore_missing: True

  'roles:local_dns':
    - match: grain
    - dnsmasq
    - ignore_missing: True

  'roles:warp10':
    - match: grain
    - java
    - warp10
    - grafana

  'roles:loki':
    - match: grain
    - loki

  'roles:smokeping':
    - match: grain
    - telegraf

  'roles:glusterfs':
    - match: grain
    - glusterfs

  'roles:webserver-back':
    - match: grain
    - glusterfs.webserver-back
    - pen
    - webhook
    - nginx
    - ignore_missing: True

  'roles:galera':
    - match: grain
    - galera

  'roles:loadbalancer':
    - match: grain
    - glusterfs.loadbalancer
    - haproxy

  'roles:dns-*':
    - match: grain
    - bind
