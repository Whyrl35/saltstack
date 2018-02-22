#------------------------------------------------------------------------------
#- SSHD_CONFI file configuration
#-
sshd_config:
  Port: 22
  Protocol: 2
  LoginGraceTime: 30
  Banner: none
  HostKey:
    - /etc/ssh/ssh_host_rsa_key
  UsePrivilegeSeparation: 'yes'
  KeyRegenerationInterval: 3600
  ServerKeyBits: 2048
  SyslogFacility: AUTH
  LogLevel: INFO
  ClientAliveInterval: 0
  ClientAliveCountMax: 3
  PermitRootLogin: no
  # PasswordAuthentication: 'yes'
  StrictModes: 'yes'
  MaxAuthTries: 3
  MaxSessions: 10
  RSAAuthentication: 'yes'
  PubkeyAuthentication: 'yes'
  IgnoreRhosts: 'yes'
  RhostsRSAAuthentication: 'no'
  HostbasedAuthentication: 'no'
  PermitEmptyPasswords: 'no'
  ChallengeResponseAuthentication: 'no'
  # AuthenticationMethods: 'publickey,keyboard-interactive'
  X11Forwarding: 'no'
  PrintMotd: 'no'
  PrintLastLog: 'no'
  TCPKeepAlive: 'yes'
  AcceptEnv: "LANG LC_*"
  Subsystem: "sftp /usr/lib/openssh/sftp-server"
  UsePAM: 'yes'
  UseDNS: 'yes'
  KexAlgorithms:
    - 'diffie-hellman-group-exchange-sha256'
  Ciphers:
    - 'chacha20-poly1305@openssh.com'
    - 'aes256-gcm@openssh.com'
    - 'aes128-gcm@openssh.com'
    - 'aes256-ctr'
  MACs:
    - 'hmac-sha2-512-etm@openssh.com'
    - 'hmac-sha2-256-etm@openssh.com'
    - 'umac-128-etm@openssh.com'
    - 'hmac-sha2-512'
    - 'hmac-sha2-256'
    - 'hmac-ripemd160'

#------------------------------------------------------------------------------
#- OPENSSH server + authorized_keys configuration
#-
openssh:
  sshd_enable: true
  auth:
    ludovic-valid-ssh-key-ks001:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: ludovic@ks001
        source: salt://ssh/keys/id_rsa_ks001.pub
    ludovic-valid-ssh-key-ovhdesk:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: lhoudaye@desk557819.ovh.net
        source: salt://ssh/keys/id_rsa_ovhdesk.pub
    ludovic-valid-ssh-key-vps:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: ludovic@vps409127.ovh.net
        source: salt://ssh/keys/id_rsa_vps001.pub
    ludovic-valid-ssh-key-srv001:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: ludovic@srv001
        source: salt://ssh/keys/id_rsa_srv001.pub
