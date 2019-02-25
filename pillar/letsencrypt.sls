letsencrypt:
  config: |
     server = https://acme-v01.api.letsencrypt.org/directory
     email = webmaster@whyrl.fr
     authenticator = webroot
     webroot-path = /var/www/html
     agree-tos = True
     renew-by-default = True
  domainsets:
  {% if 'mail_server' in grains['roles'] %}
    mail:
      - mail.whyrl.fr
      - imap.whyrl.fr
      - smtp.whyrl.fr
    web:
      - postfixadmin.whyrl.fr
      - webmail.whyrl.fr
      - rspamd.whyrl.fr
  {% endif %}
  {% if 'wazuh_server' in grains['roles'] %}
    wazuh:
      - wazuh.whyrl.fr
  {% endif %}
  {% if 'wigo_server' in grains['roles'] %}
    wigo:
      - wigo.whyrl.fr
  {% endif %}

