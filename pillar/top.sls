# vim:ft=yaml ts=2 sw=2 sts=2
{% set host = salt.grains.get('host') %}

base:
  # All minions get the following state files applied
  '*':
    - apt
    - nftables
    {% for role in grains['role'] %}
    - nftables.r_{{ role }}
    {% endfor %}
    - nftables.h_{{ host }}
    - restic
    - default
    - schedule
    - ignore_missing: True

  # All minions but not the bastion, as the ssh and host configuration is very different
  # Need to do a thebastion state to install and configure everything.
  'not bastion.whyrl.fr':
    - account
    - openssh
    - ignore_missing: True

  # Saltsatck servers
  'role:saltstack':
    - match: grain
    - webhook
    - webhook.h_{{ host }}
    {% for role in grains['role'] %}
    - webhook.r_{{ role }}
    {% endfor %}
    - ignore_missing: True

  # loadbalancer servers
  'role:loadbalancer':
    - match: grain
    - haproxy

  # Webserver
  'role:webserver':
    - match: grain
    - nginx

  # DNS servers
  'role:dns-*':
    - match: grain
    - bind

  # Domotique @home
  #'role:homeassistant':
  #  - match: grain
  #  - homeassistant
  #  - ignore_missing: True

  # DNS @home
  'role:local_dns':
    - match: grain
    - dnsmasq
    - ignore_missing: True

  # All docker servers
  'role:container':
    - match: grain
    - docker
    - docker.h_{{ host }}
    - ignore_missing: True

  # Mail server
  'role:mailserver':
    - match: grain
    - postfixadmin
    - postfix
    - dovecot
    - ignore_missing: True

  'not G@role:mailserver':
    - postfix.satellite
    - ignore_missing: True

  # Prometheus server
  'role:prometheus':
    - match: grain
    - prometheus
    - ignore_missing: True
