{% set secret = salt['vault'].read_secret('secret/salt/mail/postfix') %}

dovecot:
  extra_packages:
    - dovecot-mysql
    - dovecot-lmtpd
    - dovecot-sieve
    - dovecot-managesieved

  lookup:
    enable_service_control: True
    service_persistent: True

    config:
      dovecotext:
        sql: |
          driver = mysql
          connect = host=mysql-caaca600-o37d65b73.database.cloud.ovh.net port=20184 dbname=postfix user=postfix password={{ secret['database_password'] }}
          default_pass_scheme = SHA512-CRYPT
          user_query = SELECT '/home/vmail/%d/%n' as home, 'maildir:/home/vmail/%d/%n' as mail, 5000 AS uid, 5000 AS gid, concat('dirsize:storage=', quota) AS quota FROM mailbox WHERE username = '%u' AND active = '1'  # noqa: 204
          password_query = SELECT username as user, password, '/home/vmail/%d/%n' as userdb_home, 'maildir:/home/vmail/%d/%n' as userdb_mail, 5000 as userdb_uid, 5000 as userdb_gid FROM mailbox WHERE username = '%u' AND active = '1'  # noqa: 204
          iterate_query = SELECT username as user FROM mailbox
      conf:
        10-auth: |
          disable_plaintext_auth = no
          auth_mechanisms = plain login
          !include auth-sql.conf.ext
        10-mail: |
          mail_location = maildir:/home/vmail/%d/%n
          namespace inbox {
            inbox = yes
          }
        10-ssl: |
          ssl = required
          ssl_cert = </etc/ssl/certs/whyrl.fr.pem
          ssl_key = </etc/ssl/private/whyrl.fr.key
          ssl_ca = </etc/ssl/certs/whyrl.fr.chain.pem
          ssl_dh = </usr/share/dovecot/dh.pem
          ssl_min_protocol = TLSv1.2
          ssl_cipher_list = ALL:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH
          ssl_prefer_server_ciphers = yes
        10-master: |
          service imap-login {
            inet_listener imap {
              port = 0
            }
            inet_listener imaps {
              port = 993
              ssl = yes
            }
          }

          service lmtp {
            unix_listener /var/spool/postfix/private/dovecot-lmtp {
              mode = 0666
              user = postfix
              group = postfix
            }
          }

          service imap {
          }

          service auth {
            unix_listener /var/spool/postfix/private/auth {
              mode = 0666
              user = postfix
              group = postfix
            }
          }

          service auth-worker {
            user = vmail
          }

          service dict {
            unix_listener dict {
              mode = 0666
              user = vmail
              group = vmail
            }
          }
        20-lmtp: |
          protocol lmtp {
            mail_plugins = $mail_plugins sieve
          }
        90-sieve: |
          plugin {
            sieve = /home/vmail/%d/%n/.dovecot.sieve
            sieve_dir = /home/vmail/%d/%n/sieve
          }
