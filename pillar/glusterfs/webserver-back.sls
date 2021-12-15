#!jinja|yaml|gpg
{% from 'glusterfs/nodes.jinja' import nodes %}

include:
  - .init

glusterfs:
  client:
    mountpoints:
      webvolume:
        volume: /webvolume
        path: /srv/web/
