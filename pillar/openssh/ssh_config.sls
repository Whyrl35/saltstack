ssh_config:
  Hosts:
    '*':
      ForwardAgent: 'no'
      ForwardX11: 'no'
      PasswordAuthentication: 'yes'
      HostbasedAuthentication: 'no'
      GSSAPIAuthentication: 'no'
      GSSAPIDelegateCredentials: 'no'
      CheckHostIP: 'yes'
      AddressFamily: 'any'
      ConnectTimeout: 0
      VerifyHostKeyDNS: 'yes'
