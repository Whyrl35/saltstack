# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import glusterfs with context %}

glusterfs-node-hosts:
  file.append:
    - name: /etc/hosts
    - text:
      {% for node in glusterfs.nodes %}
      {% if node != grains['id'] %}
      {% for ip in glusterfs['nodes'][node] %}
      - {{ ip }}    {{ node }} {{ node.split('.')[0] }}
      {% endfor %}
      {% endif %}
      {% endfor %}

glusterfs-nodes-peered:
  glusterfs.peered:
    - names:
      {% for node in glusterfs.nodes %}
      {% if node != grains['id'] %}
      - {{ glusterfs['nodes'][node][0] }}
      {% endif %}
      {% endfor %}
    - require:
      - service: glusterfs-service

glusterfs-replicated-volume:
  {% for volume_name in glusterfs.volumes %}
  {% set volume = glusterfs.volumes[volume_name] %}
  glusterfs.volume_present:
    - name: {{ volume_name }}
    - bricks:
      {% for brick in volume.bricks %}
      - {{ brick }}
      {% endfor %}
    - replica: {{ volume.replica }}
    - start: {{ volume.start }}
  {% endfor %}
