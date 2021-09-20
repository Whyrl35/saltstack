# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import glusterfs with context %}

{% set glusterfs_ip_list = [] %}
{% for node in glusterfs.nodes %}
{% for ip in glusterfs['nodes'][node] %}
{% if glusterfs_ip_list.append(ip) %}{% endif %}
{% endfor %}
{% endfor %}

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

{% for mountpoint_name in glusterfs.client.mountpoints %}
{% set mountpoint = glusterfs['client']['mountpoints'][mountpoint_name] %}
glusterfs-mount-volume-{{ mountpoint_name }}:
  mount.mounted:
    - name: {{ mountpoint.path }}
    - device: {{ glusterfs_ip_list|join(',') }}:{{ mountpoint.volume }}
    - fstype: glusterfs
    - opts: _netdev,rw,defaults,direct-io-mode=disable
    - mkmnt: True
    - persist: True
    - dump: 0
    - pass_num: 0
    - device_name_regex:
      - ({{ glusterfs_ip_list|join('|') }}):/volume_name
    - require:
      - pkg: glusterfs-client-install
{% endfor %}
