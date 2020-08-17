noderig:
  cpu:    1 # CPU collector level     (Optional, default: 1)
  mem:    2 # Memory collector level  (Optional, default: 1)
  load:   2 # Load collector level    (Optional, default: 1)
  disk:   4 # Disk collector level    (Optional, default: 1)
  net:    3 # Network collector level (Optional, default: 1)
  collectors: /opt/noderig
  period: 30000

include:
  - noderig.common
