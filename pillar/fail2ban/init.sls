---
fail2ban:
  jails:
    DEFAULT:
      ignoreip: 127.0.0.1/16
      bantime: 1h
      findtime: 600
      maxretry: 3
      banaction: nftables-multiport
      chain: input
      bantime.increment: 'true'
      bantime.rndtime: '10m'
      bantime.maxtime: '1d'
      bantime.factor: 2
      dbpurgeage: '7d'
    sshd:
      enabled: 'true'
    nginx-botsearch:
      enabled: 'true'
    nginx-http-auth:
      enabled: 'true'
    recidive:
      enabled: 'true'
      banaction: nftables-allports
      bantime: 14d
      findtime: 3d
      maxretry: 3
      protocol: 0-255
