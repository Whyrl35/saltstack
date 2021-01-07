#!jinja|yaml|gpg

dehydrated:
  domains: {}
  config:
    contact-email: webmaster@whyrl.fr
    renew-days: 30
    keysize: 4096
    ca: https://acme-v02.api.letsencrypt.org/directory
  lookup:
    pkg: dehydrated
    pkg_apache: dehydrated-apache2
    #cron_command: cronic dehydrated --cron
    hook_service_to_reload: nginx postfix
    user: root
    group: root

include:
  - dehydrated.{{ host }}
