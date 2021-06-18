#- Launch the orchestrator (needed for requesits, etc...)
run_first_state:
  cmd.state.apply:
    - tgt: {{ data['name'] }}

invoke_orchestrate_cloud_creation:
  runner.state.orchestrate:
    - args:
      - mods: orchestrate.cloud_created
      - pillar:
          event_tag: {{ tag }}
          event_data: {{ data }}
