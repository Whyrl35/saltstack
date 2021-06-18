join_swarm_cluster:
  cmd.run:
    - name: 'docker swarm join --token {{ pillar["swarm"]["tokens"]["worker"] }} {{ pillar["swarm"]["masters"]["docker1.swarm.whyrl.fr"][0] }}:2377'
    - unless: 'docker info 2> /dev/null | grep "Swarm: active"'
