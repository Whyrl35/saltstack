# -*- coding: utf-8 -*-
# vim: ft=yaml
---

include:
{% if ('roles' in grains) and ('warp10' in grains['roles']) %}
  - .warp10
{% elif ('roles' in grains) and ('nexus' in grains['roles']) %}
  - .nexus
{% endif %}
