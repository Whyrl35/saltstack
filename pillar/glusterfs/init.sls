#!jinja|yaml|gpg
{% from 'glusterfs/nodes.jinja' import nodes %}

glusterfs:
  nodes:
    {% for node, ips in nodes.items() %}
    {{ node }}: {{ ips }}
    {% endfor %}

  volumes:
    webvolume:
      bricks:
        {% for node, ips in nodes.items() %}
        - {{ node }}:/mnt/glusterfs/webvolume
        {% endfor %}
      replica: 2
      start: True
