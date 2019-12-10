schedule:
  highstate:
    function: state.highstate
    minutes: 480  # every 8 hours
    splay: 1800   # splay of 30 minutes

{% if 'roles' in grains and 'saltstack' in grains['roles'] %}
  refresh_bastion:
    function: state.orchestrate
    seconds: 3600
    args:
      - orchestrate.bastion
{% endif %}
