restart-haproxy:
  runner.state.orchestrate:
    - args:
      - mods: orchestrate.haproxy_restart
    - pillar:
      event_tag: {{ tag }}
      event_data: {{ data }}
