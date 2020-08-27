{% set host = salt.grains.get('host') %}
base: #
  # Present on all hosts / common
  #
  '*':
    - schedule
    - default
    - apt
    - openssh
    - nftables
    - nftables.h_{{ host }}
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - nftables.r_{{ role }}
    {% endfor %}
    {% endif %}
    - account
    - beamium
    - beamium.h_{{ host }}
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - beamium.r_{{ role }}
    {% endfor %}
    {% endif %}
    - noderig
    - wazuh
    - wigo
    - wigo.common
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - wigo.r_{{ role }}
    {% endfor %}
    {% endif %}
    - wigo.h_{{ host }}
    - borgbackup
    - ignore_missing: True

  #
  # Specific configuration / hosts/roles based
  #
  'ks*':
    - webhook
    - webhook.h_{{ host }}
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - webhook.r_{{ role }}
    {% endfor %}
    {% endif %}
    - ignore_missing: True

  'roles:bastion':
    - match: grain
    - webhook
    - webhook.h_{{ host }}
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - webhook.r_{{ role }}
    {% endfor %}
    {% endif %}
    - ignore_missing: True

  'roles:saltstack':
    - match: grain
    - webhook
    - webhook.h_{{ host }}
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - webhook.r_{{ role }}
    {% endfor %}
    {% endif %}
    - ignore_missing: True

  'roles:container':
    - match: grain
    - docker
    - docker.h_{{ host }}
    - ignore_missing: True

  'roles:wazuh_server':
    - match: grain
    - letsencrypt
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - letsencrypt.r_{{ role }}
    {% endfor %}
    {% endif %}
    - letsencrypt.h_{{ host }}
    - nginx
    - elk.kibana
    - elk.filebeat
    - ignore_missing: True

  'roles:mail_server':
    - match: grain
    - postfix
    - mysql
    - letsencrypt
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - letsencrypt.r_{{ role }}
    {% endfor %}
    {% endif %}
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
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - letsencrypt.r_{{ role }}
    {% endfor %}
    {% endif %}
    - letsencrypt.h_{{ host }}
    - nginx
    - ignore_missing: True

  'not G@roles:borgbackup':
    - borgwrapper
    - borgwrapper.h_{{ host }}
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - borgwrapper.r_{{ role }}
    {% endfor %}
    {% endif %}
    - ignore_missing: True

  'roles:bitwarden':
    - match: grain
    - bitwarden
    - letsencrypt
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - letsencrypt.r_{{ role }}
    {% endfor %}
    {% endif %}
    - letsencrypt.h_{{ host }}
    - nginx
    - ignore_missing: True

  'roles:homeassistant':
    - match: grain
    - homeassistant
    - ignore_missing: True

  'roles:local_dns':
    - match: grain
    - dnsmasq
    - ignore_missing: True
