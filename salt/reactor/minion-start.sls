#- Launch the orchestrator (needed for requesits, etc...)
invoke_orchestrate_minion_start:
  runner.state.orchestrate:
    - args:
      - mods: orchestrate.minion_start
      - pillar:
          event_tag: {{ tag }}
          event_data: {{ data }}
