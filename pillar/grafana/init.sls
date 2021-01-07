# -*- coding: utf-8 -*-
# vim: ft=yaml
---
grafana:
  # Pillar-based config
  # See also https://grafana.com/docs/installation/configuration/
  config:
    default:
      instance_name: {{ salt.grains.get('fqdn') }}
    security:
      admin_user: admin
      x_content_type_options: false
    auth.google:
      client_secret: 0ldS3cretKey
