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
  SyslogFacility: AUTH
  LogLevel: INFO
  ClientAliveInterval: 0
  ClientAliveCountMax: 3
  PermitRootLogin: no
  # PasswordAuthentication: 'yes'
  StrictModes: 'yes'
  MaxAuthTries: 3
  MaxSessions: 10
  PubkeyAuthentication: 'yes'
  IgnoreRhosts: 'yes'
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
    - 'curve25519-sha256@libssh.org'
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

#------------------------------------------------------------------------------
#- OPENSSH server + authorized_keys configuration
#-
openssh:
  sshd_enable: true
  auth:
    ludovic-valid-ssh-key-desk:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: lhoudaye@desk
        source: salt://ssh/keys/id_rsa_desk.pub
    ludovic-valid-ssh-key-srv001:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: ludovic@srv001
        source: salt://ssh/keys/id_rsa_srv001.pub
    ludovic-valid-ssh-key-bastion:
      - user: ludovic
        present: True
        enc: ssh-rsa
        comment: bastion
        source: salt://ssh/keys/id_rsa_bastion.pub