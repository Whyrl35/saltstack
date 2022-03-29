{% set secret = salt['vault'].read_secret('secret/salt/account/root') %}

cis_2532_root_password:
  user.present:
    - name: root
    - password: {{ secret['password'] }}
    - enforce_password: True
    - hash_password: True
    - mindays: 0
    - maxdays: 99999
    - inactdays: -1
    - warndays:
    - expire: -1

cis_2666_password_quality_pkg:
  pkg.installed:
    - pkgs:
      - libpam-pwquality

cis_2666_password_quality_pam:
  file.replace:
    - name: /etc/pam.d/common-password
    - pattern: '^.*?pam_pwquality.so.*$'
    - repl: 'password\trequisite\t\t\tpam_pwquality.so retry=3'

cis_2666_password_quality_conf:
  file.keyvalue:
    - name: /etc/security/pwquality.conf
    - key_values:
        minlen: 14
        dcredit: -1
        ucredit: -1
        ocredit: -1
        lcredit: -1
    - separator: ' = '
    - uncomment: '# '
    - append_if_not_found: True

#XXX: in debian 11 pam_tally is deprecated
cis_2667_lockout_auth:
  file.line:
    - name: /etc/pam.d/common-auth
    - mode: delete
    - match: 'pam_tally2.so'

cis_2667_lockout_account:
  file.line:
    - name: /etc/pam.d/common-account
    - mode: delete
    - match: 'pam_tally2.so'

cis_2669_sh512_password:
  file.replace:
    - name: /etc/pam.d/common-password
    - pattern: '^(.*?)pam_unix.so obscure (.*)$'
    - repl: '\1pam_unix.so sha512 obscure \2'

cis_2670_password_maxage:
  file.line:
    - name: /etc/login.defs
    - mode: replace
    - match: ^PASS_MAX_DAYS
    - content: PASS_MAX_DAYS  365

cis_2671_password_minage:
  file.line:
    - name: /etc/login.defs
    - mode: replace
    - match: ^PASS_MIN_DAYS
    - content: PASS_MIN_DAYS  1

cis_2671b_password_warn:
  file.line:
    - name: /etc/login.defs
    - mode: replace
    - match: ^PASS_WARN_AGE
    - content: PASS_WARN_AGE  15

cis_2672_default_inactive_grace:
  cmd.run:
    - name: /usr/sbin/useradd -D -f 30
    - unless: useradd -D | grep INACTIVE | cut -d '=' -f2 | xargs -I% test % -gt 0

cis_2676_shell_timeout_profile_d:
  file.managed:
    - name: /etc/profile.d/10_shell_timeout.sh
    - user: root
    - group: root
    - mode: '0640'
    - contents:
      - readonly TMOUT=900 ; export TMOUT

cis_2677_restrict_su:
  file.line:
    - name: /etc/pam.d/su
    - mode: insert
    - after: auth.*required.*pam_wheel.so$
    - content: auth   required  pam_wheel.so use_uid group=sugroup

  #TODO: restric su to a group in pam

cis_2682_passwd_perm:
  file.managed:
    - name: /etc/passwd-
    - user: root
    - group: root
    - mode: '0600'

cis_2683_shadow_perm:
  file.managed:
    - name: /etc/shadow-
    - user: root
    - group: shadow
    - mode: '0640'

cis_2684_group_perm:
  file.managed:
    - name: /etc/group-
    - user: root
    - group: root
    - mode: '0600'

cis_2685_gshadow_perm:
  file.managed:
    - name: /etc/gshadow-
    - user: root
    - group: shadow
    - mode: '0640'

#cis_2686_empty_password
  #TODO: check how to implement an auto-lock of empty passowrd account

#cis_2690_only_root_uid_0:
  #TODO: onlyif `grep -v root /etc/passwd | grep -P '^\w+:\w+:0:'` => deactivate account

#cis_2691_empty_shadow_group:
  #TODO: test that the group of shadow is empty, and empty it if necessary
