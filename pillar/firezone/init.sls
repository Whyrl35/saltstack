firezone:
  configuration:
    data:
      admin_email: "ludovic@whyrl.fr"
      max_devices_per_user: 50
      egress_interface: 'ens4'
      wireguard:
        dns: '10.3.25.162, 10.3.129.242'
        ipv4:
          network: '172.16.2.0/24'
          address: '172.16.2.1'
      ssl:
        email_address: 'ludovic.houdayer@gmail.com'
        acme:
          enabled: true
        protocols: 'TLSv1.2 TLSv1.3'
      outbound_email:
        from: 'firezone@whyrl.fr'
