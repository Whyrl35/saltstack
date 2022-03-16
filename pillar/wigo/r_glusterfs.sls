---
wigo:
  extra:
    packages:
      - python3-pip
    pip:
      - glustercli
  probes:
    glusterfs: true
  probes_actives:
    glusterfs: 60
