#!jinja|yaml|gpg
borgwrapper:
  configs:
    default:
      repo: ssh://borg@borgbackup.whyrl.fr/srv/borg/{{ grains['id'] }}
      passphrase: |
        -----BEGIN PGP MESSAGE-----

        hQIMA85QH7s0WVo+AQ//SUf7KsJkEZq9PesBclWeIZ5oWT0s58dLDA/xrf08X2p6
        8yIwx/I2H+5jbSmVZShjDJONot/Eq9kmI3xd3uKxQbaYyvZXZk9+FdyBxiNHhZrY
        0fEkEVkLdX5bxNwTlNR0sJfcnyqpNI2tKLxNRoQcUFaQgRtNnT10OzqJqkt7cilu
        VnT5OfTO5eoWRL+NrDlyebXj0SYg7nU/Cit2LR8J4WLBQ9hVdn7TFW9H5jM3qQ0b
        BHsdzWv68pezUA3Q4DhWFSJgFLj8dvQm1qHI1Aag1v6Jo+EMXVBEuk2IxXxwMKc3
        JEHPqVi53zB6HQJmeHCIyxIrsKtiOalb1juFGB8AoGpZz8rMAB++iYFkoWlRCFRR
        iJigVBzD7FG7deCl2Ksd4c5N5SR840AYn5zKmdjDt8W1WVnscTKQ1ynwni9sPSTj
        IEkatfWXTfuHK0XHOKSKRmQfMls7QDGFKL2a/ZV4MO72NzXG8+jeS3V0/4LJDIeJ
        kgAiNHVrpXQXCy3mCtkl/zL+qdTX0OVG5EqVDbX79NFnp0bRcmXkbCtOIoLqFXr7
        /ktPsut7mXI+F7EKML2csfEJSHGfHuLOSBgbfKnVDG5fd2G8h8p6Bjg7oyZXcdk0
        UXFpxvlt0Nb9ILxXC57KsngVuyI5tp3vnTogn9XJDo7jv2TEJOlNG7gl5oW1WEfS
        WwGEFCMs1jkJsyAPBwL+xGLC6ypN8oozWaBJm8V6ZGtQ0xEbZ+tg+tpfiGUzLkbs
        rZPLXRCciPYLQI/9Kf43OMo6FlZuFgraFYt1EG7tmuAM+jSainFwsBgpnWI=
        =BXNK
        -----END PGP MESSAGE-----
      paths:
        - /etc
        - /srv
