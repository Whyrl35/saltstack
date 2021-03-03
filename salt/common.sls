127.0.1.1:
  host.only:
    - hostnames:
      - {{ grains['id'] }}
      - {{ grains['id'].split('.', 1)[0] }}
