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
    - postfix
    - mysql
    - letsencrypt
    - nginx
    - dovecot

  'not G@roles:mail_server':
    - postfix.satellite

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
