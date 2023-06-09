3006.x
======

# On master:

* remove old package 3005.x and rm the /opt/saltstack directory

* for external_auth:

```
The 'rest' external_auth backend requires 'keep_acl_in_token' to be True. Setting 'keep_acl_in_token' to True.
```

* missing the mysql library:

```
salt-pip install mysql-client
or
salt-pip install pyMySQL
or
...
```

# On minions:

* Need to configure vault on minions with this:

file: /etc/salt/minion.d/95_vault.conf
content:

```
vault:
    config_location: master
```

This tell the minion to fetch the configuration from the master.

* For minion with docker :

```
salt-pip install docker-py
```

Missing the right python package in the OneDir installation

* lsb grains desapeared :

```
lsb_distrib_id          => osfullname
lsb_distrib_release     => osmajorrelease
lsb_distrib_codename    => oscodename
```
