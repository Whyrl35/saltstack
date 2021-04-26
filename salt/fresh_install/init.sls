fresh_install:
  grains.present:
    - name: cloud_fresh_install
    - value: True
    - unless:
      - grep cloud_fresh_install /etc/salt/grains
