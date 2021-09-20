#!jinja|yaml|gpg
{% from 'glusterfs/nodes.jinja' import nodes %}

glusterfs:
  client:
    mountpoints:
      webvolume:
        volume: /webvolume
        path: /srv/web/
