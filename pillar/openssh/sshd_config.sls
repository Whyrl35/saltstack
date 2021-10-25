openssh:
  sshd_config_mode: '0600'

sshd_config:
  Port: 22
  Protocol: 2
  LoginGraceTime: 30
  ClientAliveInterval: 300
  ClientAliveCountMax: 0
  MaxStartups: 10:30:60
  AllowTcpForwarding: 'no'
  Banner: /etc/issue.net
  HostKey:
    - /etc/ssh/ssh_host_rsa_key
  SyslogFacility: AUTH
  LogLevel: INFO
  PermitRootLogin: 'no'
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
  GatewayPorts: 'yes'
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
