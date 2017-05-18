sshd:
  Port: 22
  ListenAddress: 0.0.0.0
  Protocol: 2
  Ciphers: aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr
  MACs: hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160
  KexAlgorithms: diffie-hellman-group-exchange-sha256
