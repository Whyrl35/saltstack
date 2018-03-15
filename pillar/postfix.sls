#!jinja|yaml|gpg

{% if grains['fqdn'] == 'mail.whyrl.fr' %}
  {% set domain = grains['domain'] %}
  {% set smtp = "smtp." ~ domain %}
{% endif %}

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

    enable_submission: False
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
    mynetworks: 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
    myorigin: {{ smtp }}
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
    smtpd_recipient_restrictions: permit_sasl_authenticated, permit_mynetworks, reject_invalid_hostname, reject_unknown_recipient_domain, reject_unauth_destination, reject_non_fqdn_hostname, reject_non_fqdn_sender, reject_non_fqdn_recipient, reject_unauth_pipelining
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
    smtpd_tls_CAfile: /etc/letsencrypt/live/mail.whyrl.fr/chain.pem
    smtpd_tls_auth_only: 'yes'
    smtpd_tls_ciphers: high
    smtpd_tls_exclude_ciphers: aNULL, eNULL, EXPORT, DES, RC4, 3DES, MD5, PSK
    smtpd_tls_fingerprint_digest: sha1
    smtpd_tls_loglevel: 1
    smtpd_tls_mandatory_ciphers: high
    smtpd_tls_received_header: 'yes'
    smtpd_tls_session_cache_database: btree:${data_directory}/smtpd_scache
    smtpd_tls_session_cache_timeout: 3600s
    smtpd_tls_cert_file: /etc/letsencrypt/live/mail.whyrl.fr/fullchain.pem
    smtpd_tls_key_file: /etc/letsencrypt/live/mail.whyrl.fr/fullchain-privkey.pem
    smtpd_tls_dh1024_param_file: /etc/postfix/dh2048.pem
    smtpd_use_tls: 'yes'

    # SMTP client
    smtp_sasl_password_maps: hash:/etc/postfix/sasl_passwd
    smtp_tls_CApath: /etc/ssl/certs
    smtp_tls_ciphers: high
    smtp_tls_fingerprint_digest: sha1
    smtp_tls_key_file: /etc/letsencrypt/live/mail.whyrl.fr/fullchain-privkey.pem
    smtp_tls_cert_file: /etc/letsencrypt/live/mail.whyrl.fr/fullchain.pem
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
    hosts: localhost
    dbname: postfix
    password: |
      -----BEGIN PGP MESSAGE-----

      hQIMA85QH7s0WVo+AQ//UdQbYyZHRGfCGKAwghSFFu11zLpix3bb8hGMPJU0MaCf
      XM9FVlt7lo2Ha3ypUtyI7dNVfQoSngEQzxDsgR/4bU9rFW9yIxR+aW28dwqbiLUU
      4IsoEN2qPcnMOTL4RazVCeDdI3xKc8UW1+hjRq1g4HuYsq6RBnaIyP6Nkr8Ny8lH
      pmdEIh6f/ZmIYu6snlgwpMPKBCBJZvSNL/TRt+j9WAkudS3k/HZBXtwmfiNFzHKH
      JbgGLljOZSwhJPSz8E8cSxUdwP5fcT9+xjEBg32kjdoMfBVdlFArbMsD0Myt1KwT
      3d9JWFlCgWY6cje4KZj8NvHWoqhMjc6l/8mRJXpvL4Yk+clTO1p5rLTGKHwK6mwl
      kq9uTNrDAQry3iplHV6w0FinMukaivhxhLnZbfzni0+kcA98ldsooOz10lQnnbpb
      U9QUn48J2AWYHuQNVG8mjuyzA9SGdUN7OD9IFA/bHaciMObqhtEIJcbdo5AMM20y
      sKybwesBlq3RpyS80qA3XP0App+tOcVGDUHsZg5YoOVwyUbFtHgNh2M3Wy5AWRWH
      yOvmTcDoLkftF3rpLVWpV9akqyVatWhLfjuERUWtrDJ9iWP/Bu/QG2l0hqwExB06
      IRJ9czUCGOm9xkR7ipNPsZ38kEVyG5nKSCOFWzZcWU5Vo1ISh9Ye+JqbRZmuFJbS
      WwHHVKkuqOd0eaw0APNLkYd94NLOx0jTgAz+0Rg6IPWGtgqKu0JeTZUlvTsE+VQp
      Xv2LgMtOTzkIwTTjL1fZZZyTDF5xUJWfnecQ5HtnvPoU4YnGGQemSva86j0=
      =Ykv9
      -----END PGP MESSAGE-----
