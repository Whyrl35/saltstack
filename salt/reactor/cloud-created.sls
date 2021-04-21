#- Launch the orchestrator (needed for requesits, etc...)
invoke_orchestrate_cloud_creation:
  runner.state.orchestrate:
    - args:
      - mods: orchestrate.cloud_created
      - pillar:
          event_tag: {{ tag }}
        event_data: {{ data|json }}
