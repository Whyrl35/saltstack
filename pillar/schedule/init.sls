schedule:
  highstate:
    function: state.apply
    minutes: 480  # every 8 hours
    splay: 1800   # splay of 30 minutes
