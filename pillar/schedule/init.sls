schedule:
  highstate:
    function: state.apply
    seconds: 3600  # every hour
    splay: 600     # splay of 10 minutes
