letsencrypt:
  use_package: false
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
  {% if grains['nodename'] == "srv002.whyrl.fr"  %}
    web:
      - whyrl.fr
      - www.whyrl.fr
      - nas.whyrl.fr
      - portainer.whyrl.fr
      - hassio.whyrl.fr
      - homepanel.whyrl.fr
      - gateway.whyrl.fr
      - extend.whyrl.fr
  {% endif %}
  {% if grains['nodename'] == "ks001.whyrl.fr"  %}
    web:
      - ks.whyrl.fr
      - www.ks.whyrl.fr
      - music.ks.whyrl.fr
      - moviecat.ks.whyrl.fr
      - warp10.ks.whyrl.fr
      - grafana.ks.whyrl.fr
  {% endif %}
  {% if grains['nodename'] == "vps001.whyrl.fr"  %}
    web:
      - saltpad.whyrl.fr
      - salt.whyrl.fr
      - vps001.whyrl.fr
  {% endif %}
  post_renew:
    cmds:
      - systemctl restart nginx
      - systemctl restart postfix
