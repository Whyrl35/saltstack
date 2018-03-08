#!jinja|yaml|gpg
mysql:
  #
  # Override vars to install mariadb instead of mysql
  #
  lookup:
    server: mariadb-server
    client: mariadb-client
    service: mariadb

  #
  # Global Configuration
  #
  global:
    client-server:
      default_character_set: utf8
    clients:
      mysql:
        default_character_set: utf8
      mysqldump:
        default_character_set: utf8
    library:
      client:
        default_character_set: utf8
  #
  # Server configuration
  #
  server:
    root_password: |
      -----BEGIN PGP MESSAGE-----

      hQIMA85QH7s0WVo+AQ//U/Yw+zxGqOh7WYD9E16+cYQmP8kllW9G6tNxocfuVdI5
      XsgkOXa10FBQRGDC7E8wV+OBOpfWjNio4xqBxfbW+Hd9R7lXP+iC9MnPUhx+gOD2
      5OppSC/lVZKC7d8NeBBbbla0ngXG1fysCXAeDElgxZvghp48ICFQuvPao7wERca6
      3YgA7s/1wV5kLdfE6czZGeT1CZJjOlN92QBfchY1KBnHisBqDHPnwA1ca23T2JDu
      XIGA9Gzwax+6uOK5oLVZ3gt9l+M+G5urfEwHN8DZTdzpwxJjxpycS5Ryz8Gak8pQ
      xo9umx6oH2OxYD7D/02azvozinbC6gKoOh/0QjVNA+/Wl1HhlHMII1qx5PhRBo9u
      4l4g/2E21SEjj/IenTYX541NctuA60ly1ZFIa5iBQDut8fi8qcf0Tik4UXIcVmBf
      enO0B+omDBbmvsgBAyU2EmvMiQV5qvl0gfv9MItlUz7ClJ+2emJeI+1YT2E1aPJT
      MoUBO893F+nL0LmL+p9IKkt6nkKUcEawV4RVWNKo9v4nL8XDM3tku3kWcWGtHQd3
      nwe8Zzecc3zth+P5CKa70jTrjFksYNWxvYP0LaUTK/igIEPjkYnfgI086ZiRZ8cT
      fztSCi481dBegRX4bVLR9l4gCS8hWi0CwhipPNRBU0hPIIO8tsIXltZ5Q5auIV7S
      WwFOw0Ay2d01inkFTGyTQ+3vLGqrwLF4Bad5oyzR/9y0lQX6dYNL3J/JOP/SBiIE
      Yn6BQuc8cEJxrvNz9a1qmDIPw5oU4N5A34u+RJ9AOFRNnu1Js1Q06EkIoyk=
      =DSYX
      -----END PGP MESSAGE-----

    mysqld:
      bind-address: 0.0.0.0
      log_bin: /var/log/mysql/mysql-bin.log
      datadir: /var/lib/mysql
      port: 3307

  ################################# MAIL SERVER ###############################

  {% if 'mail_server' in grains['roles'] %}
  #
  # Databases
  #
  database:
    - name: postfix
      character_set: utf8
      collate: utf8_general_ci
  #
  # Users
  #
  user:
    postfix:
      password: |
        -----BEGIN PGP MESSAGE-----

        hQIMA85QH7s0WVo+AQ//UdQbYyZHRGfCGKAwghSFFu11zLpix3bb8hGMPJU0MaCf
        XM9FVlt7lo2Ha3ypUtyI7dNVfQoSngEQzxDsgR/4bU9rFW9yIxR+aW28dwqbiLUU
        4IsoEN2qPcnMOTL4RazVCeDdI3xKc8UW1+hjRq1g4HuYsq6RBnaIyP6Nkr8Ny8lH
        pmdEIh6f/ZmIYu6snlgwpMPKBCBJZvSNL/TRt+j9WAkudS3k/HZBXtwmfiNFzHKH
        JbgGLljOZSwhJPSz8E8cSxUdwP5fcT9+xjEBg32kjdoMfBVdlFArbMsD0Myt1KwT
        3d9JWFlCgWY6cje4KZj8NvHWoqhMjc6l/8mRJXpvL4Yk+clTO1p5rLTGKHwK6mwl
        kq9uTNrDAQry3iplHV6w0FinMukaivhxhLnZbfzni0+kcA98ldsooOz10lQnnbpb
        U9QUn48J2AWYHuQNVG8mjuyzA9SGdUN7OD9IFA/bHaciMObqhtEIJcbdo5AMM20y
        sKybwesBlq3RpyS80qA3XP0App+tOcVGDUHsZg5YoOVwyUbFtHgNh2M3Wy5AWRWH
        yOvmTcDoLkftF3rpLVWpV9akqyVatWhLfjuERUWtrDJ9iWP/Bu/QG2l0hqwExB06
        IRJ9czUCGOm9xkR7ipNPsZ38kEVyG5nKSCOFWzZcWU5Vo1ISh9Ye+JqbRZmuFJbS
        WwHHVKkuqOd0eaw0APNLkYd94NLOx0jTgAz+0Rg6IPWGtgqKu0JeTZUlvTsE+VQp
        Xv2LgMtOTzkIwTTjL1fZZZyTDF5xUJWfnecQ5HtnvPoU4YnGGQemSva86j0=
        =Ykv9
        -----END PGP MESSAGE-----
      host: localhost
      databases:
        - database: postfix
          grants: ['all privileges']
  {% endif %}
