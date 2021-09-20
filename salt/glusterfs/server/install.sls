# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import glusterfs with context %}

{% if glusterfs.prerequisit.packages %}
glusterfs-prerequisit-install:
  pkg.installed:
    - names: {{ glusterfs.prerequisit.packages }}
{% endif %}

glusterfs-server-install:
  pkg.installed:
    - name: {{ glusterfs.package.server }}
    - require:
      - pkg: glusterfs-prerequisit-install

glusterfs-fs-load-xfs:
  cmd.run:
    - name: modprobe -v xfs
    - unless: lsmod | grep xfs
    - require:
      - pkg: glusterfs-server-install

glusterfs-fs-format:
  cmd.run:
    - name: mkfs.xfs {{ glusterfs.filesystem.device }}
    - unless: xfs_info {{ glusterfs.filesystem.device }}
    - require:
      - cmd: glusterfs-fs-load-xfs

glusterfs-fs-mounted:
  mount.mounted:
    - name: {{ glusterfs.filesystem.mount }}
    - device: {{ glusterfs.filesystem.device }}
    - fstype: xfs
    - dump: 0
    - pass_num: 2
    - persiste: True
    - mkmnt: True
    - require:
      - cmd: glusterfs-fs-format
