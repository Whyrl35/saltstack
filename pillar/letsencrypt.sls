letsencrypt:
  config: |
     server = https://acme-v01.api.letsencrypt.org/directory
     email = webmaster@whyrl.fr
     authenticator = webroot
     webroot-path = /var/www/html
     agree-tos = True
     renew-by-default = True
  {% if 'mail_server' in grains['roles'] %}
  domainsets:
    mail:
      - mail.whyrl.fr
      - imap.whyrl.fr
      - smtp.whyrl.fr
    web:
      - postfixadmin.whyrl.fr
      - webmail.whyrl.fr
      - rspamd.whyrl.fr
  {% endif %}
