base: #
  # Present on all hosts / common
  #
  '*':
    - schedule
    - default
    - apt
    - openssh
    - nftables
    - account
    - beamium
    - noderig
    - wazuh
    - wigo
    - postfix
    - postfix.satellite
    - borgbackup

  #
  # Specific configuration / hosts/roles based
  #
  'roles:saltstack':
    - match: grain
    - webhook

  'roles:container':
    - match: grain
    - docker

  'roles:wazuh_server':
    - match: grain
    - letsencrypt
    - nginx
    - elk.kibana
    - elk.filebeat

  'roles:mail_server':
    - match: grain
    - mysql
    - letsencrypt
    - nginx
    - dovecot

  'roles:webserver':
    - match: grain
    - letsencrypt
    - nginx

  'not G@roles:borgbackup':
    - borgwrapper

  'roles:bitwarden':
    - match: grain
    - bitwarden

  'roles:homeassistant':
    - match: grain
    - homeassistant
