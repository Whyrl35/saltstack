#!jinja|yaml|gpg

{% if grains['fqdn'] == 'mail.whyrl.fr' %}
{% set domain = grains['domain'] %}
{% set smtp = "smtp." ~ domain %}
{% set secret = salt['vault'].read_secret('secret/salt/databases/mysql') %}
{% from 'hosts-ips.jinja' import ips %}

##
## Mail server configuration
postfix:
  enable_service: True

  # Master configuration
  manage_master_config: True
  master_config:
    enable_dovecot: True
    dovecot:
      user: vmail
      group: vmail
      flags: DRhu
      argv: "/usr/lib/dovecot/deliver -d ${recipient}"

    enable_submission: True
    submission:
      smtpd_tls_security_level: encrypt
      smtpd_sasl_auth_enable: 'yes'
      smtpd_client_restrictions: permit_sasl_authenticated,reject

  # SPF
  #policyd-spf:
    #enabled: True
    #time_limit: 7200s

  # Postfix
  config:
    append_dot_mydomain: 'no'
    biff: 'no'
    compatibility_level: 2
    header_checks: pcre:/etc/postfix/header_checks
    html_directory: 'no'
    local_transport: virtual
    local_recipient_maps: $virtual_mailbox_maps
    readme_directory: 'no'
    recipient_delimiter: +
    strict_rfc821_envelopes: 'yes'
    #transport_maps: hash:/etc/postfix/transport

    # Alias
    alias_maps: hash:/etc/aliases
    alias_database: hash:/etc/aliases

    # Maps
    #sender_canonical_maps: hash:/etc/postfix/sender_canonical
    #relay_recipient_maps: hash:/etc/postfix/relay_domains
    #virtual_alias_maps: hash:/etc/postfix/virtual

    # Default
    default_destination_concurrency_failed_cohort_limit: 10
    default_destination_concurrency_limit: 1
    default_destination_rate_delay: 3s
    default_destination_recipient_limit: 2

    # Mailbox
    mailbox_size_limit: 0
    mailbox_command: /usr/lib/dovecot/deliver -c /etc/dovecot/dovecot.conf -m "${EXTENSION}"

    # Milter
    milter_default_action: accept
    milter_mail_macros: i {mail_addr} {client_addr} {client_name} {auth_authen}
    milter_protocol: 6

    # Network
    inet_interfaces: all
    inet_protocols: ipv4
    myhostname: {{ smtp }}
    mydestination: {{ smtp }}, localhost
    mynetworks: 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128{% for ip in ips.myhosts.static_ipv4 %} {{ ip }}{% endfor %}
    myorigin: {{ domain }}
    relay_domains: '$mydestination'
    relayhost:

    # Virtual users
    virtual_alias_maps: proxy:mysql:/etc/postfix/virtual_alias_maps.cf
    virtual_mailbox_domains: proxy:mysql:/etc/postfix/virtual_mailbox_domains.cf
    virtual_mailbox_maps: proxy:mysql:/etc/postfix/virtual_mailbox_maps.cf
    virtual_mailbox_base: /home/vmail
    virtual_mailbox_limit: 512000000
    virtual_minimum_uid: 5000
    virtual_transport: lmtp:unix:private/dovecot-lmtp
    virtual_uid_maps: static:5000
    virtual_gid_maps: static:5000

    # SMTP server
    smtpd_banner: $myhostname ESMTP $mail_name
    smtpd_helo_required: 'yes'
    smtpd_milters: inet:localhost:11332
    #can add SBL/RBL management : reject_rbl_client zen.spamhaus.org, reject_rbl_client dnsbl.sorbs.net, reject_rhsbl_reverse_client dbl.spamhaus.org, reject_rhsbl_helo dbl.spamhaus.org, reject_rhsbl_sender dbl.spamhaus.org,
    smtpd_recipient_restrictions: permit_sasl_authenticated, permit_mynetworks, reject_invalid_hostname, reject_unknown_recipient_domain, reject_unauth_destination, reject_non_fqdn_hostname, reject_non_fqdn_sender, reject_non_fqdn_recipient, reject_unauth_pipelining  # noqa: 204
    smtpd_relay_restrictions: permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
    smtpd_sasl_auth_enable: 'yes'
    smtpd_sasl_authenticated_header: 'yes'
    smtpd_sasl_local_domain: $mydomain
    #smtpd_sasl_path: /var/run/dovecot/auth-client
    smtpd_sasl_path: private/auth
    smtpd_sasl_security_options: noanonymous
    smtpd_sasl_type: dovecot
    smtpd_sasl_tls_security_options: $smtpd_sasl_security_options
    smtpd_sender_restrictions: reject_unknown_sender_domain
    smtpd_tls_CAfile: /etc/ssl/certs/whyrl.fr.chain.pem
    smtpd_tls_auth_only: 'yes'
    smtpd_tls_ciphers: high
    smtpd_tls_exclude_ciphers: aNULL, eNULL, EXPORT, DES, RC4, 3DES, MD5, PSK
    smtpd_tls_fingerprint_digest: sha1
    smtpd_tls_loglevel: 1
    smtpd_tls_mandatory_ciphers: high
    smtpd_tls_received_header: 'yes'
    smtpd_tls_session_cache_database: btree:${data_directory}/smtpd_scache
    smtpd_tls_session_cache_timeout: 3600s
    smtpd_tls_cert_file: /etc/ssl/certs/whyrl.fr.fullchain.pem
    smtpd_tls_key_file: /etc/ssl/private/whyrl.fr.key
    smtpd_tls_dh1024_param_file: /etc/postfix/dh2048.pem
    smtpd_use_tls: 'yes'

    # SMTP client
    smtp_sasl_password_maps: hash:/etc/postfix/sasl_passwd
    smtp_tls_CApath: /etc/ssl/certs
    smtp_tls_ciphers: high
    smtp_tls_fingerprint_digest: sha1
    smtp_tls_key_file: /etc/ssl/private/whyrl.fr.key
    smtp_tls_cert_file: /etc/ssl/certs/whyrl.fr.fullchain.pem
    smtp_tls_loglevel: 1
    smtp_tls_mandatory_ciphers: high
    smtp_tls_security_level: may
    smtp_tls_session_cache_database: btree:${data_directory}/smtp_scache
    smtp_use_tls: 'yes'

    # TLS
    tls_high_cipherlist: ECDH+aRSA+AES256:ECDH+aRSA+AES128:AES256-SHA:DES-CBC3-SHA
    tls_preempt_cipherlist: 'yes'

  vmail:
    user: postfix
    hosts: mysql-caaca600-o37d65b73.database.cloud.ovh.net:20184
    dbname: postfix
    password: {{ secret['postfix'] }}

  mysql:
    virtual_mailbox_domains:
      table: domain
      select_field: domain
      where_field: domain
    virtual_alias_maps:
      table: alias
      select_field: goto
      where_field: address
    virtual_mailbox_maps:
      table: mailbox
      select_field: maildir
      where_field: username

{% endif %}

{% if grains['fqdn'] != 'mail.whyrl.fr' %}
##
## Satellite configuration
postfix:
  enable_service: True

  # Postfix
  config:
    append_dot_mydomain: 'no'
    biff: 'no'
    compatibility_level: 2

    mailbox_size_limit: 0
    recipient_delimiter: +
    {% if 'role' in grains and 'container' in grains['role'] %}
    mynetworks: 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 172.0.0.0/8
    inet_interfaces: all
    {% else %}
    inet_interfaces: loopback-only
    {% endif %}
    inet_protocols: ipv4

    smtpd_sasl_auth_enable: 'yes'
    smtpd_sasl_local_domain: $mydomain
    smtpd_sasl_password_maps: hash:/etc/postfix/sasl/sasl_passwd
    smtpd_sasl_security_options: noanonymous
    smtpd_use_tls: 'yes'
    smtpd_enforce_tls: 'yes'

    myhostname: {{ grains['fqdn'] }}
    alias_maps: hash:/etc/aliases
    alias_database: hash:/etc/aliases
    myorigin: {{ grains['fqdn'] }}
    mydestination: $myorigin
    relayhost: "smtp.{{ grains['domain'] }}:587"
    smtp_generic_maps: hash:/etc/postfix/generic
{% endif %}
