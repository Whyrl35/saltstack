# -*- coding: utf-8 -*-
# vim: ft=yaml
---
redis:
  # If set, it executes: "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
  # as it is recommended for redis deployments.
  # Keep in mind that it not a persistent change so you have to put that
  # command into a rc/systemd state or modify the grub setting the
  # "transparent_hugepage=never" option and reloading the grub config
  disable_transparent_huge_pages: true

  root_dir: /var/lib/redis
  user: redis
  port: 6379
  bind: 127.0.0.1
