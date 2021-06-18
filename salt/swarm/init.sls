include:
{% if grains['id'] in ['docker1.swarm.whyrl.fr', 'docker2.swarm.whyrl.fr', 'docker3.swarm.whyrl.fr'] %}
  - .master
  - .common
{% else %}
  - .common
  - .worker
{% endif %}
