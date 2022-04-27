docker:
  containers:
    running:
      - uptime-kuma

    uptime-kuma:
      name: uptime-kuma
      image: "louislam/uptime-kuma:1"
      port_bindings:
        - 3001:3001
      binds:
        - uptime-kuma:/app/data
      start: true
      detatch: true
      auto_remove: false
      privilegde: false
      network_disabled: false
      network_mode: bridge
      restart_policy: always
