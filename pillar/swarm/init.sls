#!jinja|yaml|gpg
{% set manager_secret = salt['vault'].read_secret('secret/salt/docker/swarm/master') %}
{% set worker_secret = salt['vault'].read_secret('secret/salt/docker/swarm/worker') %}
{% from 'swarm/swarm.jinja' import swarm %}

swarm:
  masters:
    {% for master, ips in swarm.masters.items() %}
    {{ master }}: {{ ips }}
    {% endfor %}
  tokens:
    manager: {{ manager_secret['token'] }}
    worker: {{ worker_secret['token'] }}
